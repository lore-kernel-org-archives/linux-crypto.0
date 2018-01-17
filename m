From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH -next] hwrng: bcm2835 - Remove redundant dev_err call in bcm2835_rng_probe()
Date: Wed, 17 Jan 2018 11:47:58 -0800
Message-ID: <876080mfm9.fsf@anholt.net>
References: <1516189234-11957-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1516189234-11957-1-git-send-email-weiyongjun1@huawei.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain

Wei Yongjun <weiyongjun1@huawei.com> writes:

> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.

Reviewed-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlpfqG4ACgkQtdYpNtH8
nujAqA//d1bInXWbR9uj53UfIu7iEapW7aw0BI3r+OznVdI09Qbq9dSpdLGdraSS
49wvw8rAS/mjUQIWvUJdtvye4OP3720kDi3p6JUlib+ygBIbbxizkDOMsQae43Fw
/8N54XkiTTRaQBEJQ6wG2Rbdu/V/J6VWkjv67EofrRugSUJAwEso3q6yzkvaAtq7
Erom20bN0uRFnueP8+6LKWaKuATWWcph/FFQEDp0fPryCsJ3vA+Fmrj50va9RsZG
+2+Kkclr97pJNN7FL74ognNqalJOFetY0Vr54CiEcWrIdifvwDCOxMzlPMlr7l84
BN/LZNHFLbOWV/ZFgJdl7RSNRcR9AGaO/kGTtSOogkJHKRJVbehmwAvnyCv65yuX
+Je5enHQXJHvftPLjUMI/bnY0312FHvCSPWSujxl7rRGm7SdACKEQBsl4UjmomWk
lzfqvurpkStE4nEWAkhWnH/JW7XAdk8wq8rfyMdzRz79H46v/lzevEhTa8OvgACV
Pno0yTk8lKvX5v05WVkBCeyFTQXr3kTq+WNuyG/DOkR9Oiwlq6cDbaujGuuSz5fh
TVKn1P2Nz8+fYsb0exLOrPWI2zPRkV3K1IYxilmqyFFfYZdk35Z+S+85p6xX/0SB
CtGW61gnEbTQu/e9dQov432CLN5yzKKn+IR1/rG/q8QRcPQM/ks=
=h7JS
-----END PGP SIGNATURE-----
--=-=-=--
