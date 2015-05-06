From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] splice: sendfile() at once fails for big files
Date: Wed, 06 May 2015 08:23:48 -0600
Message-ID: <554A23F4.7010004@kernel.dk>
References: <20150423150308.8782B1A2439@localhost.localdomain>	<20150427070131.GA21190@gondor.apana.org.au> <CA+55aFyc+A25ozSTVNNHmBL_kUhv9u5kUq9esxjYggmqfPRE9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyc+A25ozSTVNNHmBL_kUhv9u5kUq9esxjYggmqfPRE9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/05/2015 09:41 PM, Linus Torvalds wrote:
> Jens, ping?
>
> The test results should make this a no-brainer, but I hate how random
> these flag ops.

Missed the original, apparently. I too am confused how this is a 
correctness fix and not just an optimization.

+               if (read_len < len)
+                       sd->flags |= SPLICE_F_MORE;
+               else if (!more)
+                       sd->flags &= ~SPLICE_F_MORE;

Should that check be for 'more', not '!more'?


-- 
Jens Axboe
