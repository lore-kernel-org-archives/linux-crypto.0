From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64/crypto: remove non-standard notation
Date: Tue, 21 Aug 2018 01:04:37 +0100
Message-ID: <20180821000436.GB1758@brain-police>
References: <20180820224032.53194-1-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ard.biesheuvel@linaro.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180820224032.53194-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 20, 2018 at 03:40:32PM -0700, Nick Desaulniers wrote:
> It seems that:
> ldr q8, =0x30000000200000001
> 
> is a GNU as convience notation for:
> ldr q8, .Lconstant
> .Lconstant
> .word 0x00000001
> .word 0x00000002
> .word 0x00000003
> .word 0x00000000

Does still this work correctly for a big-endian build?

Will
