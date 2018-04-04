From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 1/1] lz4: Implement lz4 with dynamic offset length.
Date: Wed, 4 Apr 2018 10:40:23 +0900
Message-ID: <20180404014023.GA5087@jagdpanzerIV>
References: <20180403122642.GA26934@jagdpanzerIV>
 <20180321074948.GA2746@jagdpanzerIV>
 <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
 <1521607242-3968-2-git-send-email-maninder1.s@samsung.com>
 <20180402055152epcms5p546fdb62381b769ed0c719f3bedcee3b8@epcms5p5>
 <CGME20180321044149epcas5p12cba1afa5fc0f493a47fe20c4a7394bd@epcms5p7>
 <576192949.596772.1522763027665.JavaMail.jboss@ep1ml501>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Maninder Singh <maninder1.s@samsung.com>,
        "sergey.senozhatsky.work@gmail.com"
        <sergey.senozhatsky.work@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PANKAJ MISHRA <pankaj.m@samsung.com>,
        AMIT SAHRA
To: Vaneet Narang <v.narang@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <576192949.596772.1522763027665.JavaMail.jboss@ep1ml501>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (04/03/18 19:13), Vaneet Narang wrote:
> Hi Sergey,
> 
> >You shrink a 2 bytes offset down to a 1 byte offset, thus you enforce that
> 2 Byte offset is not shrinked to 1 byte, Its only 1 bit is reserved out of
> 16 bits of offset. So only 15 Bits can be used to store offset value.

Yes, you are right. My bad, was thinking about something else.

> >'page should be less than 32KB', which I'm sure will be confusing. 
> lz4_dyn will work on bigger data length(> 32k) but in that case compression
> ratio may not be better than LZ4. This is same as LZ4 compressing data more 
> than 64K (16Bits). LZ4 can't store offset more than 64K similarly
> LZ4 dyn can't store offset more than 32K.

Then drop that `if PAGE_SIZE' thing. I'd rather do that stuff internally
in lz4... if it needed at all.

> >And you
> >rely on lz4_dyn users to do the right thing - namely, to use that 'nice'
> >`#if (PAGE_SIZE < (32 * KB))'. 
> They don't need to add this code

Then drop it.

> >Apart from that, lz4_dyn supports only data
> >in up to page_size chunks. Suppose my system has page_size of less than 32K,
> >so I legitimately can enable lz4_dyn, but suppose that I will use it
> >somewhere where I don't work with page_size-d chunks. Will I able to just
> >do tfm->compress(src, sz) on random buffers? The whole thing looks to be
> >quite fragile.
> No thats not true, lz4_dyn can work for random buffers and it need not be 
> of page size chunks. There is no difference in Lz4 and Lz4 dyn working. 

You are right.

	-ss
