From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: crypto_memneq not backported to 3.10
Date: Sun, 9 Apr 2017 14:59:53 +0200
Message-ID: <CAHmME9qjWeskvkVJCNnY1Xm7uAu4=gnuSsxX5KMf3kt6kqF9ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Willy,

Linux 3.10 is inexplicably missing crypto_memneq, making all crypto
mac comparisons use non constant-time comparisons. Bad news bears.

3.12 got these backported with
d68e944a8fcb2c6212b38064771c9f5af7b0b92c,
afe5a791d374e50a06ada7f4eda4e921e1b77996, and possibly others. I'd
suggest following suit, since many people are relying on this kernel
to do safe crypto.

Thanks,
Jason
