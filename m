Received: from mta1.migadu.com (out-125.mta1.migadu.com [95.215.58.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF413C4B6A
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787746659; cv=none; b=QiRa5KS+swHPkoCCp3sxiEm1gqE77bn83OrThpLjM16jGAd4+v/pJBKQzDqhqhgabuOBmmr193bRvVytrhlulIEUS6uPOlhnJnkui69DbIQvB8AGVDM0D34ljoxbzZ6VcrrJtBFTXH+KCH7hit94UwbQjBf63kvR4DP8Rzh3KFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787746659; c=relaxed/simple;
	bh=xDzobXxxxU222qeCn4cQI3aUxsYCUiL8/RnRnWerbaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bny1PEM3af1a06L4VUyK+dcY/PuD1bxwCAORxQwTsuZcNS+Mt3dV0bz1oBc1/TZ8CmSiUwZPHDcM5xHJl869XMe6oFBWw4Oxn1I8PKixPDc9c16TdrUqqU6A96kpFkioTVyHFh2Fmn9bUprYLBYuIrd/7eAPBGyb0Y8ZPxoAtf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mIfgBmX4; arc=none smtp.client-ip=95.215.58.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mIfgBmX4"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xDzobXxxxU222qeCn4cQI3aUxsYCUiL8/RnRnWerbaE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787746654; v=1; x=1788351454;
 b=mIfgBmX4NhNZjm5zWR6Iz4XNDJSMQUS+9SuWsnqYfdwsKVrxmNsq32+OOXVG7PqG4s/j9w4+
 EvNWoRwsct/CUVDHo73VES98bbCX9VdlYHCUwwO/kLozyeBvsnLEaE2OSKpRPDHoPSrKpJp4NN+
 dRIBbtMlqcKHy0Lm6/c6FiI4=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from [192.168.50.204] (146.199.86.12)
	by smtp.migadu.com with ESMTPS id d9e642eb430b8d0c;
	Wed, 26 Aug 2026 12:17:24 +0000
X-Mizu-Trace-ID: d9e642eb430b8d0c
X-Migadu-Flow: FLOW_OUT
Message-ID: <4012253e-9a7a-47cf-9c0a-75cf77677f14@linux.dev>
Date: Wed, 26 Aug 2026 13:17:23 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] crypto: zstd - avoid initializing the workspace twice
To: Yosry Ahmed <yosry@kernel.org>
Cc: davem@davemloft.net, dsterba@suse.com,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, terrelln@fb.com, hannes@cmpxchg.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260825220616.3842633-1-usama.arif@linux.dev>
 <CAO9r8zP2FLCN5N3pJR=EiNW2ykF0mwSR8fwMXPXp6SdcPd82jA@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zP2FLCN5N3pJR=EiNW2ykF0mwSR8fwMXPXp6SdcPd82jA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 25/08/2026 23:27, Yosry Ahmed wrote:
> On Tue, Aug 25, 2026 at 3:06 PM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> Both zstd_compress() and zstd_decompress() set up the shared per-CPU
>> workspace as a C/DStream before walking the request, and then, when the
>> first source and destination fragments each span the whole request, hand
>> off to zstd_compress_one()/zstd_decompress_one(), which immediately
>> overwrite that same ctx->wksp with a CCtx/DCtx. The stream setup is
>> discarded without a byte having been processed.
>>
>> That one-shot path is not a corner case: zswap always takes it when
>> storing, and takes it for a load whenever the stored object lies within a
>> single zsmalloc page.
>>
>> These two patches defer the stream initialization to the first walk
>> iteration that actually streams, guarded by a flag because that iteration
>> can be reached more than once.
>>
>> A 4 KiB crypto_acomp benchmark [1], twelve runs of nine 30,000-operation
>> rounds. Bare metal is an Intel Xeon Platinum 8321HC, turbo off,
>> performance governor, pinned to one core; the VM is a one-vCPU KVM guest
>> on a faster host.
>>
>>                   baseline    patched     delta
>>   bare metal
>>     compress      52,283 ns   51,038 ns   1,245 ns   2.4%
>>     decompress     2,317 ns    1,998 ns     319 ns  13.8%
>>   one-vCPU KVM
>>     compress      16,675 ns   15,050 ns   1,625 ns   9.8%
>>     decompress     3,516 ns    2,265 ns   1,251 ns  35.6%
> 
> Nice!
> 
>>
>> The guest numbers are larger because the two CPUID instructions in
>> ZSTD_cpuid() become unconditional VM exits there.
> 
> I wonder how much benefit we get from just doing CPUID once in
> ZSTD_cpuid() and cache the results. There might still be value in
> avoiding the overall initialization, but I think ZSTD_cpuid() should
> only be executing CPUID once anyway (e.g. in case it's called in other
> paths)?
> 


So I tried something like below and the numbers look really good on a VM:
         compression      decompression
Before   14523ns          2250ns
After    13554ns (-6.7%)  973ns (-56.8%)

commit c169757935b9c4f4d0765227cdf989515f1987a2 (HEAD -> zstd_cpuid_cache)
Author: Usama Arif <usama.arif@linux.dev>
Date:   Wed Aug 26 04:03:35 2026 -0700

    zstd: probe the CPU for BMI2 support only once

    ZSTD_cpuSupportsBmi2() issues CPUID on every context setup for an answer
    that cannot change while the kernel is running.  On x86 that is two
    serializing CPUID instructions, and the callers are not rare:
    squashfs, erofs, btrfs, f2fs and crypto/zstd all initialise a context
    per operation, so a busy squashfs or zswap workload pays for it per
    block or per page.  Under KVM it is worse, because CPUID is an
    unconditional VM exit.

    Cache the result.  Keeping the cache as a single int with a negative
    sentinel, rather than a copy of ZSTD_cpuid_t, keeps it to one word: a
    racing pair of probes computes the same value from the same CPUID leaf,
    so the unsynchronized access is benign, and READ_ONCE()/WRITE_ONCE()
    keep the compiler and KCSAN in agreement about that.

    ZSTD_cpuSupportsBmi2() is MEM_STATIC, so each translation unit that
    inlines it gets its own cache - three in a modular build, plus one in
    each preboot decompressor.  That is a handful of ints in bss and one
    extra probe apiece, not worth avoiding.

    The cached answer is the one the probing CPU reported.  zstd could
    already be migrated between the probe and the use of the flag, so this
    does not introduce a heterogeneity question that was not there before.

    Suggested-by: Yosry Ahmed <yosry@kernel.org>
    Signed-off-by: Usama Arif <usama.arif@linux.dev>

diff --git a/lib/zstd/common/zstd_internal.h b/lib/zstd/common/zstd_internal.h
index 41f190b533209..b179f44753598 100644
--- a/lib/zstd/common/zstd_internal.h
+++ b/lib/zstd/common/zstd_internal.h
@@ -312,8 +312,21 @@ size_t ZSTD_decodeSeqHeaders(ZSTD_DCtx* dctx, int* nbSeqPtr,
 MEM_STATIC int ZSTD_cpuSupportsBmi2(void)
 {
 #if DYNAMIC_BMI2
-    ZSTD_cpuid_t cpuid = ZSTD_cpuid();
-    return ZSTD_cpuid_bmi1(cpuid) && ZSTD_cpuid_bmi2(cpuid);
+    /*
+     * The answer cannot change over the life of the kernel, so probe
+     * once.  Racing probes compute the same value, so the unsynchronized
+     * access is benign; the annotations are there to keep it that way.
+     */
+    static int supported = -1;
+    int s = READ_ONCE(supported);
+
+    if (s < 0) {
+        ZSTD_cpuid_t const cpuid = ZSTD_cpuid();
+
+        s = ZSTD_cpuid_bmi1(cpuid) && ZSTD_cpuid_bmi2(cpuid);
+        WRITE_ONCE(supported, s);
+    }
+    return s;
 #else
     /* Nothing looks at the flag in this configuration. */
     return 0;

>>
>> [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
>>
>> Usama Arif (2):
>>   crypto: zstd - Avoid redundant cstream initialization
>>   crypto: zstd - Avoid redundant dstream initialization
>>
>>  crypto/zstd.c | 40 ++++++++++++++++++++++++++++------------
>>  1 file changed, 28 insertions(+), 12 deletions(-)
>>
>>
>> base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
>> --
>> 2.53.0-Meta
>>

