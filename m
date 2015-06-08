From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: randconfig build error with next-20150529, in
 crypto/jitterentropy.c
Date: Mon, 08 Jun 2015 14:36:30 +0200
Message-ID: <1433766990.1495.39.camel@twins>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com>
	 <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com>
	 <20150608122502.GA29454@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Waiman Long <Waiman.Long@hp.com>,
	Ingo Molnar <mingo@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, smueller@chronox.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150608122502.GA29454@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adding Stephan to Cc.

On Mon, 2015-06-08 at 20:25 +0800, Herbert Xu wrote:
> On Mon, Jun 08, 2015 at 03:21:09PM +0300, Andy Shevchenko wrote:
> > On Fri, May 29, 2015 at 10:14 PM, Jim Davis <jim.epost@gmail.com> wrote:
> > > Building with the attached random configuration file,
> > 
> > Hit the very same error against next-20150605.
> > 
> > The issue with that file we have no compiler optimization enabled. So,
> > guys, how you would recommend to fix it?
> 
> Stephan, can we get rid of the no optimisation requirement?

Would something like

#pragma GCC push_options
#pragma GCC optimize ("-O0")
static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
			    __u64 *folded, __u64 loop_cnt)
{
	...
}
#pragma GCC pop_options

Be an option to allow the file to be compiled with regular optimizations
enabled?
