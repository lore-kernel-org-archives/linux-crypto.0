From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] crypto: caam: Drop leading zero from input buffer
Date: Sun, 15 Apr 2018 08:07:03 -0300
Message-ID: <CAOMZO5CHXZBQoH9i3=G=53Vfju1Ue07mLH5Cqdz60m6S4G4vOw@mail.gmail.com>
References: <1523739000-27093-1-git-send-email-festevam@gmail.com> <CABatt_zxJeHAHcZLK0JPi2Ly8RPDLEaunCPLAqnuW2i1Oviivg@mail.gmail.com>
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
In-Reply-To: <CABatt_zxJeHAHcZLK0JPi2Ly8RPDLEaunCPLAqnuW2i1Oviivg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Martin,

On Sun, Apr 15, 2018 at 5:01 AM, Martin Townsend
<mtownsend1973@gmail.com> wrote:

> Fixing these things I have tested the patch on my board and have not
> seen any issues yet and it has booted to the prompt and I've checked
> /sys/kernel/security/ima/ascii_runtime_measurements and can see all
> the files that have been measured. :)

Thanks for your feedback.

I have just sent a v2 with your suggestions.

If it works well for you, please reply with your Tested-by tag.

Thanks
