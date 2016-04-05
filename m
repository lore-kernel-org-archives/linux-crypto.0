From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 00/14] lib/mpi: bug fixes and cleanup
Date: Tue, 5 Apr 2016 20:47:33 +0800
Message-ID: <20160405124733.GJ13048@gondor.apana.org.au>
References: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 22, 2016 at 01:12:34PM +0100, Nicolai Stange wrote:
> Former v2 can be found here:
> 
>   http://lkml.kernel.org/g/1458566775-5239-1-git-send-email-nicstange@gmail.com
> 
> 
> This v3 series incorporates a fix to the pointer arithmetic issue in v2's
> [8/14] ("lib/mpi: mpi_read_buffer(): fix buffer overflow") spotted by
> Tadeusz Struk.
> 
> The rest, that is [1-7,9-14/14], go unchanged and have got a
> 
>   Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>
> 
> already.
> 
> 
> Applicable to linux-next-20160322.

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
