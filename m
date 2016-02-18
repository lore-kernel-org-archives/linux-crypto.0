From: Willy Tarreau <w@1wt.eu>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Thu, 18 Feb 2016 01:01:28 +0100
Message-ID: <20160218000128.GA31168@1wt.eu>
References: <56C47DF9.6030704@whissi.de> <56C485AA.5060303@oracle.com> <56C49096.6040904@whissi.de> <56C4F068.8060806@oracle.com> <20160217233353.GC31125@1wt.eu> <56C50725.6080408@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Thomas D." <whissi@whissi.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C50725.6080408@whissi.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 18, 2016 at 12:49:57AM +0100, Thomas D. wrote:
> Hi
> 
> Willy Tarreau wrote:
> >> Is there a dependency I missed in 4.1? I don't really see anything that
> >> could have gone wrong there.
> > 
> > Or maybe Thomas can run a bisect ?
> 
> I cannot follow. I did a bisect between 4.1.7 and 4.1.8 as I have written
> in my first mail. The bad commit was:
> 
> > commit 0571ba52a19e18a1c20469454231eef681cb1310

Ah sorry, I missed this one, I was confused by the test results on the
more recent kernels. So indeed, only this patch's backport has to be
studied.

Thanks and sorry for the noise.

Willy
