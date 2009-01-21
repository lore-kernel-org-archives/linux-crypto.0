From: Andreas Steffen <andreas.steffen@strongswan.org>
Subject: Linux 2.6.28 and AEAD initialization
Date: Wed, 21 Jan 2009 03:29:48 +0100
Message-ID: <4976889C.3090602@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sidv0150.hsr.ch ([152.96.52.150]:52599 "EHLO strongswan.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbZAUCwL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Jan 2009 21:52:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

with the Linux 2.6.28 kernel the first time xfrm_user.c:xfrm_add_sa()
is called with either "rfc4106(gcm(aes))" or "rfc4309(ccm(aes))",
an EEXIST error is returned and the installation of the IPsec SA fails.
A detailed analysis of the function calls (see trace added below) shows
that aead.c:crypto_lookup_aead() first loads

name         : rfc4106(gcm(aes))
driver       : rfc4106(gcm_base(ctr(aes-generic)))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : nivaead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : seqiv

Because of type=nivaead

    if (alg->cra_type == &crypto_aead_type)
        return alg;

crypto_lookup_aead() does not return the algorithm and falls through
to the statement

    return ERR_PTR(crypto_nivaead_default(alg, type, mask));

which makes another call to algapi.c;__crypto_register_alg().
Because the driver has already been installed

    ret = -EEXIST;
    ...

	if (crypto_is_larval(q)) {
	    if (!strcmp(alg->cra_driver_name, q->cra_driver_name))
	        goto err;
	    continue;
	}

__crypto_register_alg() exits with the EEXIST error code.

The second time around the type=aead algorithm is additionally loaded

name         : rfc4106(gcm(aes))
driver       : rfc4106(gcm_base(ctr(aes-generic)))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : aead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : seqiv

name         : rfc4106(gcm(aes))
driver       : rfc4106(gcm_base(ctr(aes-generic)))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : nivaead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : seqiv

and the IPsec SAs can be set up successfully.

With the Linux 2.6.27.10 and earlier kernels the aead type is
loaded right at the beginning and no problems occur:

name         : rfc4106(gcm(aes))
driver       : rfc4106(gcm_base(ctr(aes-asm)))
module       : kernel
priority     : 200
refcnt       : 1
type         : aead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : seqiv

name         : rfc4106(gcm(aes))
driver       : rfc4106(gcm_base(ctr(aes-asm)))
module       : kernel
priority     : 200
refcnt       : 1
type         : nivaead
async        : yes
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : seqiv

Best regards

Andreas

Trace of function calls returning EEXIST:

-----------------------------------------------------------------------------
net/xfrm/xfrm_user.c:xfrm_add_sa()
{
	x = xfrm_state_construct(p, attrs, &err);
	if (!x)
		return err;
}

-----------------------------------------------------------------------------
net/xfrm/xfrm_user.c:xfrm_state_construct()
{
	err = xfrm_init_state(x);
	if (err)
		goto error;
    ...
error:
	x->km.state = XFRM_STATE_DEAD;
	xfrm_state_put(x);
error_no_put:
	*errp = err;
	return NULL;
}

-----------------------------------------------------------------------------
net/xfrm/xfrm_state.c:xfrm_init_state()
{
	x->type = xfrm_get_type(x->id.proto, family);
	if (x->type == NULL)
		goto error;

	err = x->type->init_state(x);
	if (err)
		goto error;
    ...
error:
	return err;
}

-----------------------------------------------------------------------------
linux/net/xfrm.h:struct xfrm_type
{
	char			*description;
	struct module		*owner;
	__u8			proto;
	__u8			flags;
#define XFRM_TYPE_NON_FRAGMENT	1
#define XFRM_TYPE_REPLAY_PROT	2
#define XFRM_TYPE_LOCAL_COADDR	4
#define XFRM_TYPE_REMOTE_COADDR	8

	int			(*init_state)(struct xfrm_state *x);
	void			(*destructor)(struct xfrm_state *);
	int			(*input)(struct xfrm_state *, struct sk_buff *skb);
	int			(*output)(struct xfrm_state *, struct sk_buff *pskb);
	int			(*reject)(struct xfrm_state *, struct sk_buff *, struct flowi *);
	int			(*hdr_offset)(struct xfrm_state *, struct sk_buff *, u8 **);
	/* Estimate maximal size of result of transformation of a dgram */
	u32			(*get_mtu)(struct xfrm_state *, int size);
};

-----------------------------------------------------------------------------
net/ipv4/esp4.c:esp_init_state()
{
	if (x->aead)
		err = esp_init_aead(x);
	}
	else
		err = esp_init_authenc(x);

	if (err)
		goto error;

}

-----------------------------------------------------------------------------
net/ipv4/esp4.c:esp_init_aead()
{
	struct esp_data *esp = x->data;
	struct crypto_aead *aead;
	int err;

	aead = crypto_alloc_aead(x->aead->alg_name, 0, 0);
	err = PTR_ERR(aead);
	if (IS_ERR(aead))
		goto error;

error:
	return err;
}

-----------------------------------------------------------------------------
crypto/aead.c:crypto_alloc_aead()
{
		alg = crypto_lookup_aead(alg_name, type, mask);
		if (IS_ERR(alg)) {
			err = PTR_ERR(alg);
			goto err;
		}

err:
		if (err != -EAGAIN)
			break;
		if (signal_pending(current)) {
			err = -EINTR;
			break;
		}
	}

	return ERR_PTR(err);
}

-----------------------------------------------------------------------------
crypto/aead.c:crypto_lookup_aead()
{
	struct crypto_alg *alg;

	alg = crypto_alg_mod_lookup(name, type, mask);
	if (IS_ERR(alg))
		return alg;

    /* after the first call alg->cra_type is &crypto_nivaead_type */

	if (alg->cra_type == &crypto_aead_type)
		return alg;

	if (!alg->cra_aead.ivsize)
		return alg;

	return ERR_PTR(crypto_nivaead_default(alg, type, mask));
}

-----------------------------------------------------------------------------
crypto/aead.c:crypto_nivaead_default()
{
	if ((err = crypto_register_instance(tmpl, inst))) {
		tmpl->free(inst);
		goto put_tmpl;
	}

	/* Redo the lookup to use the instance we just registered. */
	err = -EAGAIN;

put_tmpl:
	crypto_tmpl_put(tmpl);
kill_larval:
	crypto_larval_kill(larval);
drop_larval:
	crypto_mod_put(larval);
out:
	crypto_mod_put(alg);
	return err;
}

-----------------------------------------------------------------------------
crypto/algapi.c:crypto_register_instance()
{
	larval = __crypto_register_alg(&inst->alg);
	if (IS_ERR(larval))
		goto unlock;

	hlist_add_head(&inst->list, &tmpl->instances);
	inst->tmpl = tmpl;

unlock:
	up_write(&crypto_alg_sem);

	err = PTR_ERR(larval);
	if (IS_ERR(larval))
		goto err;

	crypto_wait_for_test(larval);
	err = 0;

err:
	return err;
}

-----------------------------------------------------------------------------
crypto/algapi.c:__crypto_register_alg()
{
	ret = -EEXIST;
    ...

		if (crypto_is_larval(q)) {
			if (!strcmp(alg->cra_driver_name, q->cra_driver_name))
				goto err;
			continue;
		}
}

Uff!

======================================================================
Andreas Steffen                         andreas.steffen@strongswan.org
strongSwan - the Linux VPN Solution!                www.strongswan.org
              Institute for Internet Technologies and Applications
University of Applied Sciences Rapperswil
CH-8640 Rapperswil (Switzerland)
===========================================================[ITA-HSR]==

