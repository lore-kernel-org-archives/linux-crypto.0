From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/4] lib: Update LZ4 compressor module
Date: Sun, 22 Jan 2017 01:38:20 +0800
Message-ID: <201701220138.lulmlSvI%fengguang.wu@intel.com>
References: <1485011351-7463-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, anton@enomsg.org, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com,
        phillip@squashfs.org.uk,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485011351-7463-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Sven,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.10-rc4 next-20170120]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sven-Schmidt/Update-LZ4-compressor-module/20170121-231418
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> lib/lz4/lz4_decompress.c:521:21: sparse: incompatible types for operation (>)
   lib/lz4/lz4_decompress.c:521:21:    left side has type unsigned long [usertype] *src_len
   lib/lz4/lz4_decompress.c:521:21:    right side has type int

vim +521 lib/lz4/lz4_decompress.c

   505				return -1;
   506	}
   507	EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
   508	
   509	int lz4_decompress(const unsigned char *src, size_t *src_len,
   510		unsigned char *dest, size_t actual_dest_len) {
   511		*src_len = LZ4_decompress_fast(src, dest, (int)actual_dest_len);
   512	
   513		/*
   514		 * Prior lz4_decompress will return
   515		 * 0 for success and a negative result for error
   516		 * new LZ4_decompress_fast returns
   517		 * - the length of data read on success
   518		 * - and also a negative result on error
   519		 * meaning when result > 0, we just return 0 here
   520		 */
 > 521		if (src_len > 0)
   522			return 0;
   523		else
   524			return -1;
   525	}
   526	EXPORT_SYMBOL(lz4_decompress);
   527	
   528	MODULE_LICENSE("Dual BSD/GPL");
   529	MODULE_DESCRIPTION("LZ4 decompressor");

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
