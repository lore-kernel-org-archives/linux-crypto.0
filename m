From: Andy Polyakov <appro@openssl.org>
Subject: Re: [PATCH v3] crypto: arm64/sha2: integrate OpenSSL implementations
 of SHA256/SHA512
Date: Sun, 13 Nov 2016 16:12:35 +0100
Message-ID: <c8306030-d4eb-fea7-441a-3476cd308496@openssl.org>
References: <1478953953-11523-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161112221520.GD24127@arm.com>
 <CAKv+Gu_Y-ik0L9mh4z-g3fHKjPt780_znCQNU-jAwXifLgAo4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Will Deacon <will.deacon@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu_Y-ik0L9mh4z-g3fHKjPt780_znCQNU-jAwXifLgAo4A@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

> (+ Andy)
> 
> ...
>>
>> Looking at the generated code, I see references to __ARMEB__ and
> __ILP32__.
>> The former is probably a bug,

Oh! You mean that it should be __AARCH64EB__/__AARCH64EL__! Apparently I
simply went on assuming that it would be __ARMEB__/__ARMEL__ even in
64-bit case. As Ard mentioned, there is a number of modules that can be
compiled for either 32- or 64-bit case, and supposedly that's where this
blunder stems from. Will fix... As for it being actually tested. No, I
don't have big-endian AArch64 setup, and big-endian segments in AArch64
are based on experience with endian neutrality elsewhere. I.e. it's
based on observations what it takes to achieve the neutrality elsewhere,
e.g. ARM, MIPS, PPC, and then exercising equivalent approach even here.
Modulo fact that I apparently got macros wrong :-(

>> whilst the second is not required.

Note that references to __ILP32__ are also inside #ifndef
__KERNEL__/#endif, i.e. they won't be even evaluated when compiled for
kernel. Or in other words it's shared code artefact just like #if[n]def
__KERNEL__ itself. You either disregard it or remove altogether, but
then code becomes specific and not shared :-)

>> There are
>> also some commented out instructions, which is weird.

Commented instructions denote those that are moved into next round in
order to improve instruction scheduling on either of processors. In
other words it means that you should spot it further below [in generated
code]. Yes, it's weird, but it helps me to remember which instructions
are moved. On side note it's not uncommon that instruction scheduling is
result of compromise. In general I attempt to schedule instruction for
near-optimal performance on *multiple* processors, but sometimes you
have to make compromises. One is mentioned in commentary section for
this very module, the Apple A7 vs. Cortex-A53 thing. Well, it's not like
the commented instruction you're observing is the only result of the
compromise, it's merely an example of how said compromises can manifest
themselves, as somewhat weird irregularities in the code, possibly with
commented instructions.
