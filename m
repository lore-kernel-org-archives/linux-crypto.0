From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: Does /dev/urandom now block until initialised ?
Date: Mon, 23 Jul 2018 12:11:12 -0400
Message-ID: <CAH8yC8kT=OBjxX8ye9GYec5Hs2NORtPtf8e6DPxP8JiUH9BNyg@mail.gmail.com>
References: <CANVEwpbaU5=wMT_iSh9XrkmbLvqKjx4+v6PDizamaY0gWvk-mg@mail.gmail.com>
 <20180723151608.GE3358@thunk.org>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ken Moffat <zarniwhoop73@googlemail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180723151608.GE3358@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 23, 2018 at 11:16 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Mon, Jul 23, 2018 at 04:43:01AM +0100, Ken Moffat wrote:
>> ...
> One of the reasons why I didn't see the problem when I was developing
> the remediation patch for CVE-2018-1108 is because I run Debian
> testing, which doesn't have this particular Red Hat patch.

Off-topic, I'm kind of surprised it took that long to fix it (if I am
parsing things correctly).

I believe Stephan Mueller wrote up the weakness a couple of years ago.
He's the one who explained the interactions to me. Mueller was even
cited at https://github.com/systemd/systemd/issues/4167.

It is too bad he Mueller not receive credit for it in the CVE database.

Jeff
