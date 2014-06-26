From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Jun 26 (crypto/drbg)
Date: Thu, 26 Jun 2014 08:08:55 -0700
Message-ID: <53AC3787.7090309@infradead.org>
References: <20140626164130.4d01a3b2@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20140626164130.4d01a3b2@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/25/14 23:41, Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc allyesconfig is again broken more than usual.
> 
> Changes since 20140625:
> 


on i386:

../crypto/drbg.c:1097:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'size_t' [-Wformat]
../crypto/drbg.c:1966:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'unsigned int' [-Wformat]
../crypto/drbg.c:1966:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]


-- 
~Randy
