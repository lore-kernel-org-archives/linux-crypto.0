From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: select on non-existing Kconfig option CRC32C
Date: Wed, 15 Jun 2016 07:40:37 -0700
Message-ID: <576168E5.9020009@infradead.org>
References: <5761275B.4010508@fau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andreas Ziegler <andreas.ziegler@fau.de>,
	Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5761275B.4010508@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/15/16 03:00, Andreas Ziegler wrote:
> Hi Hendrik,
> 
> your patch "s390/crc32-vx: add crypto API module for optimized CRC-32
> algorithms" showed up in linux-next today (next-20160615) as commit 	364148e0b195.
> 
> The patch defines the Kconfig option CRYPTO_CRC32_S390 which 'select's CRC32C.
> However, this should probably have been CRYPTO_CRC32C, as CRC32C does not exist.
> Should I prepare a trivial patch to fix this up or would you like to do that on
> your side?
> 
> I found this issue by comparing yesterday's tree and today's tree using
> 'scripts/checkkconfigsymbols -f -d next-20160614..next-20160615'.

or should it select CRC32 or LIBCRC32C?  (probably not the LIB... one)

-- 
~Randy
