From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Sat, 4 Aug 2018 20:28:59 -0400
Message-ID: <20180805002859.GG4461@thunk.org>
References: <20180718014344.1309-1-tytso@mit.edu>
 <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
 <20180718142625.GA5942@thunk.org>
 <20180804215209.GA3201@localhost>
 <20180805002514.GF4461@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pavel Machek <pavel@ucw.cz>, Yann Droneaud <ydroneaud@opteya.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180805002514.GF4461@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 04, 2018 at 08:25:14PM -0400, Theodore Y. Ts'o wrote:
> Depending on your hardware, no mouse motion might be necessary at all.
> On my laptop (a Dell XPS 13 model 9370) using an dm-crypt protected
> root disk, and running a Debian testing userspace, with a 4.18-rc6
> based kernel, the "CRNG is initialized" message is printed *before*
> the root file system is mounted.

Sorry, correction.  It's printed *before* the root file system is
remounted read/write.  (Which means before we can generate long-term
public keys and save them to the file system.)

						- Ted
