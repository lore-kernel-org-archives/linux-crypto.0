From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2 3/4] hw_random: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Sun, 28 Aug 2016 23:29:08 +0530
Message-ID: <CANc+2y6vqXTrCyU3HRUi0YybWzyvmVbCsB2r+8U44786QQp1sA@mail.gmail.com>
References: <1472321697-3094-1-git-send-email-prasannatsmkumar@gmail.com>
 <1472321697-3094-4-git-send-email-prasannatsmkumar@gmail.com> <7a3874e2-069e-7bdf-2289-3364ec2c8cc4@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: mpm@selenic.com, Herbert Xu <herbert@gondor.apana.org.au>,
        robh+dt@kernel.org, mark.rutland@arm.com,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        boris.brezillon@free-electrons.com, harvey.hunt@imgtec.com,
        prarit@redhat.com, Florian Fainelli <f.fainelli@gmail.com>,
        joshua.henderson@microchip.com, narmstrong@baylibre.com,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@linux-mips.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <7a3874e2-069e-7bdf-2289-3364ec2c8cc4@cogentembedded.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: linux-crypto.vger.kernel.org

>>         cgu: jz4780-cgu@10000000 {
>>                 compatible = "ingenic,jz4780-cgu";
>> -               reg = <0x10000000 0x100>;
>> +               reg = <0x10000000 0xD8>;
>
>
>    I think lower case is preferred here.

Sure, will change.
