From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 0/1] cover-letter/lz4: Implement lz4 with dynamic offset
 length.
Date: Wed, 21 Mar 2018 15:41:28 +0900
Message-ID: <20180321064128.GA468@jagdpanzerIV>
References: <CGME20180321044137epcas5p221e7ee4a0b7464eaa00dad8320f0251d@epcas5p2.samsung.com>
 <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        minchan@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, keescook@chromium.org,
        anton@enomsg.org, ccross@android.com, tony.luck@intel.com,
        akpm@linux-foundation.org, colin.king@canonical.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pankaj.m@samsung.com, a.sahrawat@samsung.com, v.narang@samsung.com
To: Maninder Singh <maninder1.s@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (03/21/18 10:10), Maninder Singh wrote:
> (Added cover letter to avoid much text in patch description)
> 
> LZ4 specification defines 2 byte offset length for 64 KB data.
> But in case of ZRAM we compress data per page and in most of
> architecture PAGE_SIZE is 4KB. So we can decide offset length based
> on actual offset value. For this we can reserve 1 bit to decide offset
> length (1 byte or 2 byte). 2 byte required only if ofsset is greater than 127,
> else 1 byte is enough.

So what happens if I compress the data on a system with no dyn
offset and then send it over the network to a machine which has
dyn offset? Or, say, I have a USB stick with a compression enabled
FS, store files on a dyn offset enabled PC and then mount that USB
stick on a machine with no dyn offset support. And vice versa.

	-ss
