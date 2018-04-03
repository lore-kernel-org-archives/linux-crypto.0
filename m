From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 1/1] lz4: Implement lz4 with dynamic offset length.
Date: Tue, 3 Apr 2018 21:26:42 +0900
Message-ID: <20180403122642.GA26934@jagdpanzerIV>
References: <20180321074948.GA2746@jagdpanzerIV>
 <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
 <1521607242-3968-2-git-send-email-maninder1.s@samsung.com>
 <CGME20180321044149epcas5p12cba1afa5fc0f493a47fe20c4a7394bd@epcms5p5>
 <20180402055152epcms5p546fdb62381b769ed0c719f3bedcee3b8@epcms5p5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "sergey.senozhatsky.work@gmail.com"
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
        AMIT SAHRAWAT <a.sahrawat@samsung.com>,
        Vaneet Naran
To: Maninder Singh <maninder1.s@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180402055152epcms5p546fdb62381b769ed0c719f3bedcee3b8@epcms5p5>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (04/02/18 11:21), Maninder Singh wrote:
[..]
> >>  static const char * const backends[] = {
> >>          "lzo",
> >>  #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
> >>          "lz4",
> >> +#if (PAGE_SIZE < (32 * KB))
> >> +        "lz4_dyn",
> >> +#endif
> > 
> >This is not the list of supported algorithms. It's the list of
> >recommended algorithms. You can configure zram to use any of
> >available and known to Crypto API algorithms. Including lz4_dyn
> >on PAGE_SIZE > 32K systems.
> > 
> Yes, we want to integrate new compression(lz4_dyn) for ZRAM 
> only if PAGE_SIZE is less than 32KB to get maximum benefit. 
> so we added lz4_dyn to available list of ZRAM compression alhorithms.

Which is not what I was talking about.

You shrink a 2 bytes offset down to a 1 byte offset, thus you enforce that
'page should be less than 32KB', which I'm sure will be confusing. And you
rely on lz4_dyn users to do the right thing - namely, to use that 'nice'
`#if (PAGE_SIZE < (32 * KB))'. Apart from that, lz4_dyn supports only data
in up to page_size chunks. Suppose my system has page_size of less than 32K,
so I legitimately can enable lz4_dyn, but suppose that I will use it
somewhere where I don't work with page_size-d chunks. Will I able to just
do tfm->compress(src, sz) on random buffers? The whole thing looks to be
quite fragile.

	-ss
