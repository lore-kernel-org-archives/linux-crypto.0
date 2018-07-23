From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Does /dev/urandom now block until initialised ?
Date: Mon, 23 Jul 2018 15:11:20 -0400
Message-ID: <20180723191120.GA3670@thunk.org>
References: <CANVEwpbaU5=wMT_iSh9XrkmbLvqKjx4+v6PDizamaY0gWvk-mg@mail.gmail.com>
 <20180723151608.GE3358@thunk.org>
 <CAH8yC8kT=OBjxX8ye9GYec5Hs2NORtPtf8e6DPxP8JiUH9BNyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ken Moffat <zarniwhoop73@googlemail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
To: Jeffrey Walton <noloader@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH8yC8kT=OBjxX8ye9GYec5Hs2NORtPtf8e6DPxP8JiUH9BNyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 23, 2018 at 12:11:12PM -0400, Jeffrey Walton wrote:
> 
> I believe Stephan Mueller wrote up the weakness a couple of years ago.
> He's the one who explained the interactions to me. Mueller was even
> cited at https://github.com/systemd/systemd/issues/4167.

Stephan had a lot of complaints about the existing random driver.
That's because he has a replacement driver that he has been pushing,
and instead of giving explicit complaints with specific patches to fix
those specific issues, he have a generalized blast of complaints, plus
a "big bang rewrite".

I've reviewed his lrng doc, and this specific issue was not among his
complaints.  Quite a while ago, I had gone through his document, and
had specifically addressed each of his complaints.  As far as I have
been able determine, all of the specific technical complaints (as
opposed to personal preference issues) have been addressed.

His complaint is a text book complaint about how *not* to file a bug
report.  That being said, we try to take bug reports from as many
sources as possible even if they aren't well formed or submitted in
the ideal place.

(I'm reminded of Linux's networking scalability limitations which
Microsoft filed in the Wall Street Journal 15+ years ago --- and which
only applied if you had 4 CPU's and four 10 megabit networking cards;
if you had four CPU's and a 100 megabit networking card, Linux would
grind Microsoft into the dust; still it was a bug, and we appreciated
the report and we fixed it, even if it wasn't filed in the ideal
forum.  :-)

> It is too bad he Mueller not receive credit for it in the CVE database.

As near as I can tell, he doesn't deserve it for this particular
issue.  It's all Jann Horn and Google's Project Zero.  (And his
writeup is a textbook example of how to report this sort of issue with
great specifity and analysis.)

						- Ted
