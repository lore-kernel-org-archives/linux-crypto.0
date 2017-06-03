From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [kernel-hardening] Re: get_random_bytes returns bad randomness
 before seeding is complete
Date: Fri, 2 Jun 2017 20:20:26 -0400
Message-ID: <CACXcFmmx0cGXoF7ng+OKcXeP7w-Q39H8Fe2LMeRkyvX3NdAL3g@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <20170602172616.47qcxav6adq52nmk@thunk.org> <CAHmME9oS_GCRMLf7EF8XBGwjdjohcRz4rzZiWr5ZDUurTj8A7Q@mail.gmail.com>
 <20170602190734.6zll7zc5hr66oacl@thunk.org> <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:36855 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFCAU2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2017 20:20:28 -0400
In-Reply-To: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The only sensible & general solution for the initialisation problem
that I have seen is John Denker's.
http://www.av8n.com/computer/htm/secure-random.htm#sec-boot-image

If I read that right, it would require only minor kernel changes &
none to the API Ted & others are worrying about. It would be secure
except against an enemy who can read your kernel image or interfere
with your install process. Assuming permissions are set sensibly, that
means an enemy who already has root & such an enemy has lots of much
easier ways to break things, so we need not worry about that case.

The difficulty is that it would require significant changes to
installation scripts. Still, since it is a general solution to a real
problem, it might be better to implement that rather than work on the
other suggestions in the thread.
