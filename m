From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Wed, 28 Sep 2016 09:28:44 -0300
Message-ID: <20160928122844.GC15729@gallifrey>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com>
 <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com>
 <20160926145934.GA5520@gondor.apana.org.au>
 <20160926174317.GA21317@gallifrey>
 <20160927030826.GB8579@gondor.apana.org.au>
 <346154437.225735.1474966863173.JavaMail.zimbra@redhat.com>
 <20160927120414.GC21317@gallifrey>
 <20160927194644.GB15729@gallifrey>
 <20160928024549.GB14034@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Cc: Jan Stancek <jstancek@redhat.com>,
        rui y wang <rui.y.wang@intel.com>,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36827 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932179AbcI1M2w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 08:28:52 -0400
Received: by mail-qk0-f169.google.com with SMTP id z190so44666969qkc.3
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2016 05:28:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160928024549.GB14034@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Herbert,

On Wed, Sep 28, 2016 at 10:45:49AM +0800, Herbert Xu wrote:
> On Tue, Sep 27, 2016 at 04:46:44PM -0300, Marcelo Cerri wrote:
> >
> > Can you check if the problem occurs with this patch?
>
> In light of the fact that padlock-sha is the correct example
> to follow, you only need to add one line to the init_tfm fucntion
> to update the descsize based on that of the fallback.
>

Not sure if I'm missing something here but p8_ghash already does that:

 56 static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
 57 {
 ...
 83         shash_tfm->descsize = sizeof(struct p8_ghash_desc_ctx)
 84             + crypto_shash_descsize(fallback);
 85
 86         return 0;
 87 }

I think the problem here is that crypto_ahash_statesize uses the
statesize value (that is initialized with the descsize value from
shash_alg) instead of using the value from the tfm that was updated.

For padlock_sha1, it uses the value from alg->statesize since it defines
import and export functions. It doesn't make much difference if it uses
the value from descsize or statesize here, what really matter is that
it uses the value defined in struct shash_alg and not from the tfm.

The big difference between p8_ghash and padlock_sha1 is that
padlock_sha1 defines alg->statesize as sizeof(struct sha1_state), which
is the descsize value used by sha1_generic. This probably works but
it's also wrong because the padlock_sha1 driver does not ensures that
sha1_generic is always used.

So, one solution is to hardcode ghash-generic as the fallback algorithm
and update the descsize direct in its shash_alg structure. There's only
one problem with that. ghash-generic desc type (struct ghash_desc_ctx)
is not available for vmx_crypto at compile type, the type is defined
directly in crypto/ghash-generic.c. That's the reason I added a function
to get the fallback desc size at runtime in the patch I wrote as a prove
of concept.

--
Regards,
Marcelo

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEbBAABCAAGBQJX67d7AAoJEM8aS8c01e1HV+wH+NzTqXC585iDbmHPhJTlW8Xr
S/zQ8ChtBnTothllUIVyFC/VGWYtG9WkP0XFr8EKMSMq2cXs+oBKFCQqLQ7Ym4ky
yohRdJlN8nTj0T79S46VOaGSIbMgUsFPEzzi9gIcOU3LtjUz3rXYrNgkoOP+E4Ri
FVysrFMUOrjyRiANXHHkZzeIBbFfu2OoVNq5zJh+/m+L0EMPZoZFOsanzY/F3qsv
VH6K35hL6ZPsudxtNkG7rnJGmuHEglMCvPaHkLHw1t1GOg+OAJHpwhdQI6gs7qPp
iEjRR53gNUOA5uxgrhHRuYzRU9OeiH3lHkX4GviDFSZIORt53Gdfd2frt2mEBA==
=G0Ds
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--
