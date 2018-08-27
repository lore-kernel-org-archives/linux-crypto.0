From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/4] arm64: wire CRC32 instructions into core crc32 routines
Date: Mon, 27 Aug 2018 17:18:26 +0200
Message-ID: <CAKv+Gu_qz+HbU2HQ2ep0cN-9V5hA46sBNVoxvkyjDQ=ZGk8yfw@mail.gmail.com>
References: <20180827110245.14812-1-ard.biesheuvel@linaro.org> <20180827145352.GF2311@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827145352.GF2311@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 27 August 2018 at 16:53, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Mon, Aug 27, 2018 at 01:02:41PM +0200, Ard Biesheuvel wrote:
>> While this is not known to cause performance issues, calling a table based
>> time variant implementation with a non-negligible D-cache footprint (8 KB)
>> is wasteful in any case, and now that the crc32 instructions have been made
>> mandatory in the architecture, let's wire them up into the core crc routines.
>
> Stupid question --- are there any arm64 SOC's out there which do *not*
> have the crc32 instructions?  Presumably there won't be in the future,
> because it's now mandatory --- but where there any in the past?
>

Yes, the APM Xgene for instance.
