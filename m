From: Willy Tarreau <w@1wt.eu>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Thu, 18 Feb 2016 00:33:53 +0100
Message-ID: <20160217233353.GC31125@1wt.eu>
References: <56C47DF9.6030704@whissi.de> <56C485AA.5060303@oracle.com> <56C49096.6040904@whissi.de> <56C4F068.8060806@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>,
	"Thomas D." <whissi@whissi.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C4F068.8060806@oracle.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 17, 2016 at 05:12:56PM -0500, Sasha Levin wrote:
> On 02/17/2016 10:24 AM, Thomas D. wrote:
> > Hi,
> > 
> > Sasha Levin wrote:
> >> > So either the upstream patch is broken, or the 4.1 backport is wrong/missing
> >> > dependency/missing fix.
> >> > 
> >> > Any chance you could try 4.5-rc3 and see if that works for you? That'll narrow
> >> > it down a lot.
> > 4.5-rc3 works for me.
> > 
> > Linux-4.4.0 works, too.
> 
> Herbert,
> 
> Is there a dependency I missed in 4.1? I don't really see anything that
> could have gone wrong there.

Or maybe Thomas can run a bisect ? Thomas, do you feel comfortable with
doing this ? There are a few patches between 4.1.17 and 4.1.18, in 8
steps it should be done, and only 4 if you limit yourself to the crypto
directory. Stable versions are fast at bisecting because each patch
touches a very isolated area so only the first build takes a bit of
time but the other ones are often pretty fast. Finding the faulty
patch can help spotting if something is wrong in its backport.

Regards,
Willy
