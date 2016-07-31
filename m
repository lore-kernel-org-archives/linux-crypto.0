From: Alex Xu via Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: getrandom waits for a long time when /dev/random is
	insufficiently read from
Date: Sat, 30 Jul 2016 21:53:46 -0400
Message-ID: <20160730215346.7a2714a7.alex_y_xu@yahoo.ca>
References: <20160728180732.12d38880@alex-desktop>
	<2622345.NpnZjxROFX@tauon.atsec.com>
	<20160729101407.03123327.alex_y_xu@yahoo.ca>
	<2790164.RXkTBNoHIv@tauon.atsec.com>
	<20160729133114.37ff14ef.alex_y_xu@yahoo.ca>
	<20160730220922.GA12853@thunk.org>
Reply-To: Alex Xu <alex_y_xu@yahoo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20160730220922.GA12853@thunk.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 30 Jul 2016 18:09:22 -0400
Theodore Ts'o <tytso@mit.edu> wrote as excerpted:
> On Fri, Jul 29, 2016 at 01:31:14PM -0400, Alex Xu wrote:
> > When qemu is started with -object rng-random,filename=/dev/urandom,
> > and immediately (i.e. with no initrd and as the first thing in
> > init):
> > 
> > 1. the guest runs dd if=/dev/random, there is no blocking and tons
> > of data goes to the screen. the data appears to be random.
> > 
> > 2. the guest runs getrandom with any requested amount (tested 1 byte
> > and 16 bytes) and no flags, it blocks for 90-110 seconds while the
> > "non-blocking pool is initialized". the returned data appears to be
> > random.
> > 
> > 3. the guest runs getrandom with GRND_RANDOM with any requested
> > amount, it returns the desired amount or possibly less, but in my
> > experience at least 10 bytes. the returned data appears to be
> > random.
> > 
> > I believe that the difference between cases 1 and 2 is a bug, since
> > based on my previous statement, in this scenario, getrandom should
> > never block.  
> 
> This is correct; and it has been fixed in the patches in v4.8-rc1.
> The patch which fixes this has been marked for backporting to stable
> kernels:
> 
> commit 3371f3da08cff4b75c1f2dce742d460539d6566d
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Jun 12 18:11:51 2016 -0400
> 
>     random: initialize the non-blocking pool via
> add_hwgenerator_randomness() 
>     If we have a hardware RNG and are using the in-kernel rngd, we
> should use this to initialize the non-blocking pool so that
> getrandom(2) doesn't block unnecessarily.
>     
>     Cc: stable@kernel.org
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> Basically, the urandom pool (now CSRPNG) wasn't getting initialized
> from the hardware random number generator.  Most people didn't notice
> because very few people actually *use* hardware random number
> generators (although it's much more common in VM's, which is how
> you're using it), and use of getrandom(2) is still relatively rare,
> given that glibc hasn't yet seen fit to support it yet.
> 
> Cheers,
> 
> 					- Ted

Dammit, the one time I track down an actual kernel bug someone's already
fixed it. I'd even bothered to check 4.6 so I figured nobody'd gotten
around to it yet.

Thanks for the excellent explanations though. :)
