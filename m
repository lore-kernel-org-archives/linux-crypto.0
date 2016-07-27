From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] /dev/random driver changes for 4.8
Date: Wed, 27 Jul 2016 09:12:37 -0400
Message-ID: <20160727131237.GF9284@thunk.org>
References: <20160725064424.GA29098@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160725064424.GA29098@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 25, 2016 at 02:44:24AM -0400, Theodore Ts'o wrote:
> The following changes since commit 1a695a905c18548062509178b98bc91e67510864:
> 
>   Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus
> 
> for you to fetch changes up to 86a574de4590ffe6fd3f3ca34cdcf655a78e36ec:
> 
>   random: strengthen input validation for RNDADDTOENTCNT (2016-07-03 17:09:33 -0400)

Hi Linus,

Are you planning on pulling the random tree this cycle?  I'm not sure
if you wanted to let it soak for a few days in linux-next, or whether
you want to wait another full release cycle, given that the random
tree had gotten dropped from linux-next some time ago without my
realizing it.  (The code has actually been soaking for 1.5 releases,
since I wanted to give it lots of soak time, but of course, it would
have been more helpful if it actually was in linux-next.  Sigh...)

     	       	       	     	      	  - Ted
