From: Stephan Mueller <smueller@chronox.de>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Mon, 08 Jun 2015 17:52:49 +0200
Message-ID: <2190933.vdB90a64Et@tauon.atsec.com>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com> <20150608122502.GA29454@gondor.apana.org.au> <1433766990.1495.39.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Waiman Long <Waiman.Long@hp.com>,
	Ingo Molnar <mingo@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1433766990.1495.39.camel@twins>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Monday 08 June 2015, 14:36:30 schrieb Peter Zijlstra:

Hi Peter,
>
>Would something like
>
>#pragma GCC push_options
>#pragma GCC optimize ("-O0")
>static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
>			    __u64 *folded, __u64 loop_cnt)
>{
>	...
>}
>#pragma GCC pop_options
>
>Be an option to allow the file to be compiled with regular optimizations
>enabled?

After doing some tests, I see that neither the min entropy nor the Shannon 
Entropy of the raw noise is affected by using the mentioned pragmas at the 
right locations.

So I will prepare a patch tonight.

Just for my edification: why does an -O0 on a self contained file break the 
compile run? Any why do the pragmas work?

Thanks
Stephan
