From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 14:05:11 +0100
Message-ID: <20150324130511.GK14457@ns203013.ovh.net>
References: <20150316154835.GA31336@google.com>
 <20150323135009.GB820@google.com>
 <20150324122702.GJ14457@ns203013.ovh.net>
 <CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Andy Polyakov <appro@openssl.org>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

 >> +     '&eor   ($t0,$t0,$a,"ror#".($Sigma0[2]-$Sigma0[0]))',   # Sigma0(a)
> >> +     '&add   ($h,$h,$t1)',                   # h+=Ch(e,f,g)
> >> +     '&ldr   ($t1,sprintf "[sp,#%d]",4*(($j+1)&15))  if (($j&15)!=15);'.
> >> +     '&ldr   ($t1,"[$Ktbl]")                         if ($j==15);'.
> >> +     '&ldr   ($t1,"[sp,#64]")                        if ($j==31)',
> >> +     '&and   ($t3,$t3,$t2)',                 # (b^c)&=(a^b)
> >> +     '&add   ($d,$d,$h)',                    # d+=h
> >> +     '&add   ($h,$h,$t0,"ror#$Sigma0[0]");'. # h+=Sigma0(a)
> >> +     '&eor   ($t3,$t3,$b)',                  # Maj(a,b,c)
> >> +     '$j++;  unshift(@V,pop(@V)); ($t2,$t3)=($t3,$t2);'
> >> +     )
> >> +}
> >> +
> >> +$code.=<<___;
> >> +#if __ARM_MAX_ARCH__>=7
> > this will be compile on armv4 but gcc will not allow it
> >
> > we need to drop the neon code for older non v7 build
> >
> 
> The .arch and .fpu declarations ensure that it can be built regardless
> of the platform you are compiling for, unless you have a really old
> toolchain.
I known but does not work for me
> The glue code ensures that the module can only be loaded if HWCAP_NEON is set.
> 
> Did you get errors trying to build it?

yes I do

I use 

arm-none-linux-gnueabi-gcc (Sourcery CodeBench Lite 2014.05-29) 4.8.3 20140320
(prerelease)
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

so it's not that old

Best Regards,
J.
