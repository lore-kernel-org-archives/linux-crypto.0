From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/crypto: fix %progbits -> @progbits
Date: Wed, 25 Jan 2017 14:37:08 -0800
Message-ID: <8ad0ec8d-a7d2-b4ca-df7d-3b670b468baf@zytor.com>
References: <20170119212805.18049-1-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        Megha Dey <megha.dey@intel.com>,
        George Spelvin <linux@horizon.com>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170119212805.18049-1-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/19/17 13:28, Denys Vlasenko wrote:
> %progbits form is used on ARM (where @ is a comment char).
> 
> x86 consistently uses @progbits everywhere else.

However, it looks like %progbits works on all architectures (at least
include/linux/init.h seems to imply so.)  Perhaps a tree-wide
replacement the other way would make more sense.

Personally I would also like to see these parameters macroized, to keep
someone from getting them wrong, just like we have __INIT, __INITRODATA
etc already, we should just have plain __TEXT __DATA __BSS...

	-hpa
