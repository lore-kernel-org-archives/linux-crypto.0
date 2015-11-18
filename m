From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] crypto: atmel: fix bogus select
Date: Wed, 18 Nov 2015 20:54:03 +0100
Message-ID: <3878434.NqzKGChk39@wuerfel>
References: <201511190227.fHF3LVfw%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Leilei Zhao <leilei.zhao@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	linux-kernel@vger.kernel.org,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201511190227.fHF3LVfw%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 19 November 2015 02:17:21 kbuild test robot wrote:
> 
> [auto build test WARNING on: cryptodev/master]
> [also build test WARNING on: v4.4-rc1 next-20151118]
> 
> url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/crypto-atmel-fix-bogus-select/20151118-233706
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: tile-allmodconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=tile 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/crypto/atmel-aes.c: In function 'atmel_aes_sg_copy':
> >> drivers/crypto/atmel-aes.c:191:11: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>    drivers/crypto/atmel-aes.c: In function 'atmel_aes_crypt_dma_start':
>    drivers/crypto/atmel-aes.c:447:11: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>    drivers/crypto/atmel-aes.c:448:11: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>    drivers/crypto/atmel-aes.c: In function 'atmel_aes_crypt_dma_stop':
> >> drivers/crypto/atmel-aes.c:642:5: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t' [-Wformat]
>    drivers/crypto/atmel-aes.c: In function 'atmel_aes_buff_init':
> >> drivers/crypto/atmel-aes.c:669:3: warning: format '%d' expects argument of type 'int', but argument 3 has type 'size_t' [-Wformat]
>    drivers/crypto/atmel-aes.c:677:3: warning: format '%d' expects argument of type 'int', but argument 3 has type 'size_t' [-Wformat]
> 
> 

Thanks for the report. I actually submitted a patch for these yesterday, but
I should have realized now that there is a dependency between the two patches,
and the other one needs to be applied first to avoid generating these
warnings in allmodconfig builds for all architectures.

	Arnd
