From: Andy Polyakov <appro@openssl.org>
Subject: Re: [PATCH] arm64: add support for SHA256 using NEON instructions
Date: Fri, 30 Sep 2016 12:44:13 +0200
Message-ID: <a11d5dcc-1681-7e62-c3ac-f2fd53c50f14@openssl.org>
References: <1475189503-9175-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: catalin.marinas@arm.com, victor.chong@linaro.org, will.deacon@arm.com,
 daniel.thompson@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 herbert@gondor.apana.org.au
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1475189503-9175-1-git-send-email-ard.biesheuvel@linaro.org>
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

> This is a port of the ARMv7 implementation in arch/arm/crypto. For a Cortex-A57
> (r2p1), the performance numbers are listed below. In summary, 40% - 50% speedup
> where it counts, i.e., block sizes over 256 bytes with few updates.

Cool! Great! Just in case for reference. You compare generic, new NEON
and hardware-assisted implementations. I assume that first one refers to
C compiler-generated code. But there is another option, i.e. non-NEON
assembly. Now to the "for reference" part. The reason for why NEON is
not utilized in OpenSSL is because it's deemed that it doesn't provide
"extraordinary" improvement over non-NEON assembly code, especially on
less sophisticated processors such as Cortex-A53. Note that I'm not
saying that NEON SHA256 subroutine is not faster, it is, only that it's
not "extraordinarily" faster in most relevant cases(*). In other words
it's reckoned that non-NEON assembly provides adequate *all-round*
performance, taking into consideration that it does it without being
dependent on optional NEON. Non-NEON assembly should also be interesting
in kernel context, because there are situations when you can't call NEON
procedure, be it suggested one or hardware-assisted, which itself relies
on NEON. And of course another nice quality about SHA2 module in OpenSSL
is that it emits both SHA256 and SHA512 codes ;-) On related note it
should be noted that NEON-izing SHA512 on ARM64 makes lesser sense, it's
bound to provide lesser improvement than SHA256 [if any at all in some
cases]. This is because in SHA256 you engage 4 lanes of NEON registers,
while in SHA512 case you have only 2.

(*) Well, this is also question of priorities. My rationale is that
there is a lot of Cortex-A53 and A57 phones out there that don't have
crypto-extensions, I refer to Qualcomm SoCs, where NEON gives less than
10% improvement [over non-NEON assembly]. Yes, it gives more on X-Gene,
but X-Gene is not wide-spread, and the rest (including upcoming X-Gene)
have crypto-extensions, so alternative code path doesn't matter.
