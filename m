From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 4/4] crypto: s5p-sss - Use mutex instead of spinlock
Date: Fri, 17 Mar 2017 19:54:05 +0200
Message-ID: <20170317175405.hkvhbnzoeplksxkk@kozik-lap>
References: <20170317144922.27379-1-krzk@kernel.org>
 <20170317144922.27379-5-krzk@kernel.org>
 <CGME20170317172831epcas1p12280386c43fd0b819bb87cf4ba78eab3@epcas1p1.samsung.com>
 <4289522.7Nbtc4pSSm@amdc3058>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Nathan Royce <nroycea+kernel@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4289522.7Nbtc4pSSm@amdc3058>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 17, 2017 at 06:28:29PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Friday, March 17, 2017 04:49:22 PM Krzysztof Kozlowski wrote:
> > Driver uses threaded interrupt handler so there is no real need for
> > using spinlocks for synchronization.  Mutexes would do fine and are
> > friendlier for overall system preemptivness and real-time behavior.
> 
> Are you sure that this conversion is safe?  This driver also uses
> a tasklet and tasklets run in the interrupt context.
>

Yes, you're right. This is not safe and patch should be dropped. Thanks
for spotting this.

Best regards,
Krzysztof
