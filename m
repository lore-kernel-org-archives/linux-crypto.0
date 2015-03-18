From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.0
Date: Wed, 18 Mar 2015 11:12:44 -0700
Message-ID: <CA+55aFwsoYA1TL416etgckndxqSEicp7Cdi-rfXwxUJoc_2MUA@mail.gmail.com>
References: <20120823083242.GA23102@gondor.apana.org.au>
	<20121109093005.GA25632@gondor.apana.org.au>
	<20130328082841.GA7425@gondor.apana.org.au>
	<20131203124129.GA12067@gondor.apana.org.au>
	<20131209115705.GA1361@gondor.apana.org.au>
	<20140101061016.GA22579@gondor.apana.org.au>
	<20140203125944.GA31446@gondor.apana.org.au>
	<20141231033217.GA27261@gondor.apana.org.au>
	<20150107021737.GA25043@gondor.apana.org.au>
	<20150309051950.GA1526@gondor.apana.org.au>
	<20150318052517.GA20347@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150318052517.GA20347@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 17, 2015 at 10:25 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Hi Linus:
>
> On Mon, Mar 09, 2015 at 04:19:50PM +1100, Herbert Xu wrote:
>>
>> This push fixes a bug in the ARM XTS implementation that can
>> cause failures to in decrypting encrypted disks.
>
> For some reason this didn't get pulled so I'm resending it with
> another fix.

Hmm. I never got your original email. Maybe it was in my spam folder
and my spam scan never noticed..

                        Linus
