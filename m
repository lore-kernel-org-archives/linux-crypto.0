From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/4] arm64: wire CRC32 instructions into core crc32
 routines
Date: Mon, 27 Aug 2018 10:53:52 -0400
Message-ID: <20180827145352.GF2311@thunk.org>
References: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, ebiggers@google.com,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180827110245.14812-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 27, 2018 at 01:02:41PM +0200, Ard Biesheuvel wrote:
> While this is not known to cause performance issues, calling a table based
> time variant implementation with a non-negligible D-cache footprint (8 KB)
> is wasteful in any case, and now that the crc32 instructions have been made
> mandatory in the architecture, let's wire them up into the core crc routines.

Stupid question --- are there any arm64 SOC's out there which do *not*
have the crc32 instructions?  Presumably there won't be in the future,
because it's now mandatory --- but where there any in the past?

	     	 	       	   	 - Ted
