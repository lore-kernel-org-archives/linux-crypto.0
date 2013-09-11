From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] modules: add support for soft module dependencies
Date: Wed, 11 Sep 2013 14:40:03 +1000
Message-ID: <20130911044003.GA30913@gondor.apana.org.au>
References: <20130724071757.GA30970@gondor.apana.org.au>
 <87siz38q2t.fsf@rustcorp.com.au>
 <20130725020329.GA14625@gondor.apana.org.au>
 <CAKi4VA+=1vOOt0BqdQHQaeF1hP3DrRtCL_ObXY0cPeO7S_MtYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Andreas Robinson <andr345@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Zhao Hongjiang <zhaohongjiang@huawei.com>,
	David Miller <davem@davemloft.net>, tim.c.chen@linux.intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org,
	linux-modules <linux-modules@vger.kernel.org>,
	Tom Gundersen <teg@jklm.no>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKi4VA+=1vOOt0BqdQHQaeF1hP3DrRtCL_ObXY0cPeO7S_MtYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 10, 2013 at 11:01:38AM -0300, Lucas De Marchi wrote:
>
> However looking at the only user right now, crct10dif: couldn't we
> detect at runtime if this module can be used instead of just trying to
> load it as a pre softdep and possibly failing?

No as sd_mod requires crct10dif to be present.  The use of softdep
as opposed to just a symbolic dependency is due to there being two
modules for crct10dif, a generic version and an arch-specific one.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
