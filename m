From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2] crypto: caam: Drop leading zero from input buffer
Date: Sun, 15 Apr 2018 11:16:18 -0300
Message-ID: <CAOMZO5D5ffJhuLq9_eJDNNeCtQZ+ZL5wkSQ7EAGULmaQRfbpug@mail.gmail.com>
References: <1523790224-26083-1-git-send-email-festevam@gmail.com> <CABatt_zL94FcfD6JK+a8LpgT411WpFQ69tto4a12ZJOTz0pX2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Breno Lima <breno.lima@nxp.com>,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        stable <stable@vger.kernel.org>
To: Martin Townsend <mtownsend1973@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CABatt_zL94FcfD6JK+a8LpgT411WpFQ69tto4a12ZJOTz0pX2w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 15, 2018 at 10:52 AM, Martin Townsend
<mtownsend1973@gmail.com> wrote:

> Sorry to be a pain but looking at the other use cases for
> caam_rsa_drop_leading_zeros they check len afterwards which makes more
> sense to me as temp being NULL after this operation is very unlikely
> :) and I suppose we are trying to catch the case where the data is all
> zeroes which wouldn't be a valid signature.

You are right. I have just sent a v3 that checks len after
caam_rsa_drop_leading_zeros().

Thanks
