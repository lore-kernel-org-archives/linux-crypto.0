From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Mon, 26 Sep 2016 11:15:10 -0300
Message-ID: <20160926141510.GC5031@gallifrey>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Cc: rui.y.wang@intel.com, herbert@gondor.apana.org.au,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33187 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966216AbcIZOPQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 10:15:16 -0400
Received: by mail-qk0-f178.google.com with SMTP id g67so104302773qkd.0
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2016 07:15:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

Just out of curiosity, have you tried to use "76" on both values to
check if the problem still happens?

--=20
Regards,
Marcelo

On Fri, Sep 23, 2016 at 08:22:27PM -0400, Jan Stancek wrote:
> Hi,
>=20
> I'm chasing a memory corruption with 4.8-rc7 as I'm observing random Oops=
es
> on ppc BE/LE systems (lpars, KVM guests). About 30% of issues is that
> module list gets corrupted, and "cat /proc/modules" or "lsmod" triggers
> an Oops, for example:
>=20
> [   88.486041] Unable to handle kernel paging request for data at address=
 0x00000020
> ...
> [   88.487658] NIP [c00000000020f820] m_show+0xa0/0x240
> [   88.487689] LR [c00000000020f834] m_show+0xb4/0x240
> [   88.487719] Call Trace:
> [   88.487736] [c0000004b605bbb0] [c00000000020f834] m_show+0xb4/0x240 (u=
nreliable)
> [   88.487796] [c0000004b605bc50] [c00000000045e73c] seq_read+0x36c/0x520
> [   88.487843] [c0000004b605bcf0] [c0000000004e1014] proc_reg_read+0x84/0=
x120
> [   88.487889] [c0000004b605bd30] [c00000000040df88] vfs_read+0xf8/0x380
> [   88.487934] [c0000004b605bde0] [c00000000040fd40] SyS_read+0x60/0x110
> [   88.487981] [c0000004b605be30] [c000000000009590] system_call+0x38/0xec
>=20
> 0x20 offset is module_use->source, module_use is NULL because module.sour=
ce_list
> gets corrupted.
>=20
> The source of corruption appears to originate from a 'ahash' test for p8_=
ghash:
>=20
> cryptomgr_test
>  alg_test
>   alg_test_hash
>    test_hash
>     __test_hash
>      ahash_partial_update
>       shash_async_export
>        memcpy
>=20
> With some extra traces [1], I'm seeing that ahash_partial_update() alloca=
tes 56 bytes
> for 'state', and then crypto_ahash_export() writes 76 bytes into it:
>=20
> [    5.970887] __test_hash alg name p8_ghash, result: c000000004333ac0, k=
ey: c0000004b860a500, req: c0000004b860a380
> [    5.970963] state: c000000004333f00, statesize: 56
> [    5.970995] shash_default_export memcpy c000000004333f00 c0000004b860a=
3e0, len: 76
>=20
> This seems to directly correspond with:
>   p8_ghash_alg.descsize =3D sizeof(struct p8_ghash_desc_ctx) =3D=3D 56
>   shash_tfm->descsize =3D sizeof(struct p8_ghash_desc_ctx) + crypto_shash=
_descsize(fallback) =3D=3D 56 + 20
> where 20 is presumably coming from "ghash_alg.descsize".
>=20
> My gut feeling was that these 2 should match, but I'd love to hear
> what crypto people think.
>=20
> Thank you,
> Jan
>=20
> [1]
> diff --git a/crypto/shash.c b/crypto/shash.c
> index a051541..49fe182 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -188,6 +188,8 @@ EXPORT_SYMBOL_GPL(crypto_shash_digest);
>=20
>  static int shash_default_export(struct shash_desc *desc, void *out)
>  {
> +       int len =3D crypto_shash_descsize(desc->tfm);
> +       printk("shash_default_export memcpy %p %p, len: %d\n", out, shash=
_desc_ctx(desc), len);
>         memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(desc->tfm=
));
>         return 0;
>  }
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 5c9d5a5..2e54579 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -218,6 +218,8 @@ static int ahash_partial_update(struct ahash_request =
**preq,
>                 pr_err("alt: hash: Failed to alloc state for %s\n", algo);
>                 goto out_nostate;
>         }
> +       printk("state: %p, statesize: %d\n", state, statesize);
> +
>         ret =3D crypto_ahash_export(req, state);
>         if (ret) {
>                 pr_err("alt: hash: Failed to export() for %s\n", algo);
> @@ -288,6 +290,7 @@ static int __test_hash(struct crypto_ahash *tfm, stru=
ct hash_testvec *template,
>                        "%s\n", algo);
>                 goto out_noreq;
>         }
> +       printk("__test_hash alg name %s, result: %p, key: %p, req: %p\n",=
 algo, result, key, req);
>         ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>                                    tcrypt_complete, &tresult);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX6S1uAAoJEM8aS8c01e1HIsQIAJjnXCL/ikliWPBSdGIqpeU2
eKfqEp8BYzg9/mYp9B2Yrnw4tq4WlG1ZU1fpX45H6Q0Mg3y0iimojo+iA21fsgMw
I9kb1K1iQEwUlPq5zeotydXZunIkBdHsb7SI6OvKfvRChSJ7UGo5o2EgLn/G9XB1
z7vdKjTysbU2fCiFlm4V8piD2xDS3GY6NwxBhpGRsljJfa40vGBHVK1Z/zIudOvK
HbLA0ANhX7WpkCYfpY0CMtuM/5vpojQ714PIvIwj1MQYDtRS+ZNkiZEGYTQmjFrE
JF7Imh0Zf9lezlGAMQA3Fpil24X/Vmit2tQPWIQbd3q/GncHz4zjU5037PPqYXg=
=tlV6
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
