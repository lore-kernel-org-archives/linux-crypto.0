From: Maninder Singh <maninder1.s@samsung.com>
Subject: Re: [PATCH 1/1] lz4: Implement lz4 with dynamic offset length.
Date: Mon, 02 Apr 2018 11:21:52 +0530
Message-ID: <20180402055152epcms5p546fdb62381b769ed0c719f3bedcee3b8@epcms5p5>
References: <20180321074948.GA2746@jagdpanzerIV>
        <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
        <1521607242-3968-2-git-send-email-maninder1.s@samsung.com>
        <CGME20180321044149epcas5p12cba1afa5fc0f493a47fe20c4a7394bd@epcms5p5>
Reply-To: maninder1.s@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
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
        Vaneet Narang <v.narang@samsung.com>
To: "sergey.senozhatsky.work@gmail.com"
        <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321074948.GA2746@jagdpanzerIV>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

>> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
>> index 4ed0a78..5bc5aab 100644
>> --- a/drivers/block/zram/zcomp.c
>> +++ b/drivers/block/zram/zcomp.c
>> @@ -17,11 +17,15 @@
>>  #include <linux/crypto.h>
>>  
>>  #include "zcomp.h"
>> +#define KB        (1 << 10)
>>  
>>  static const char * const backends[] = {
>>          "lzo",
>>  #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
>>          "lz4",
>> +#if (PAGE_SIZE < (32 * KB))
>> +        "lz4_dyn",
>> +#endif
> 
>This is not the list of supported algorithms. It's the list of
>recommended algorithms. You can configure zram to use any of
>available and known to Crypto API algorithms. Including lz4_dyn
>on PAGE_SIZE > 32K systems.
> 
>        -ss
 
Yes, we want to integrate new compression(lz4_dyn) for ZRAM 
only if PAGE_SIZE is less than 32KB to get maximum benefit. 
so we added lz4_dyn to available list of ZRAM compression alhorithms.

Thanks,
Manider Singh
