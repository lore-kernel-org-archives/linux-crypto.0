Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30B9C83F12
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Aug 2023 19:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjH2Tif (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Aug 2023 15:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbjH2TiY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2023 15:38:24 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA73CC
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2023 12:38:21 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 77224320094A;
        Tue, 29 Aug 2023 15:38:18 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 29 Aug 2023 15:38:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1693337897; x=1693424297; bh=2x38gz0Jg0jJtRU+GnKumqKqMkwkMsScX3v
        BhuwPSBI=; b=THy/m6SGvl4Ic6qB0NQ919Taoaplv2eFKTgITdjopBvvIYxyD8B
        UZx0ZQJe53lmrTrbqRGyePgEbzn1Nk9msmjX1uJwJBQCczlfvwQHKN/w1xHDEZl0
        vQw+ja4QibN1MbSQB9uOM9e4QswDSWdK1M9JFpJmTBnlgb1fOYqTZrMiXknw+TeA
        DQhvXPoWmsGU9uSlgsdh1XGGU+UnRxUdn9G0z6xytQK2xIE1vlhZOYCbtTgmAtAh
        8q08BsRwy90eFgpUuWyg29oO8efAD9A16DG4bybFj1AZNDqEZegxlvznPpSMwMsn
        R2he31l+MPh8jIFjMppaK0ZUINQCcB/kukQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1693337897; x=1693424297; bh=2x38gz0Jg0jJtRU+GnKumqKqMkwkMsScX3v
        BhuwPSBI=; b=DMuXylexEtWhF1ghhPIK+NHbZX4pSv/UZaxcuq0MQO55t/sZOrb
        JosCh5tsNOSR5DcSDft5C5ZZIHmWDSHgEXb0o0ns0VGAiFxitWCGmZ5EnfCq+8sU
        6mxCSFO3J6E07n2iRNnOC2zbaT8GrPSwU3p1eupljkWU6AoXODDQZ6wRmeRjwkkl
        hCeVLoB/V9yMdxFS25xf2+t1XCFOgwLayaFsJiktYaiZtXDdW6ctpdPGN8SWM30d
        ILg6zErfdfy5u1To47O7kS0/3+zt3AukeiPEfIz3qXoanuBJAzYfMr5Qq5wkIlRs
        sPiMou04RReDMmKeqfxlv0gV1fRhrzRWaaw==
X-ME-Sender: <xms:KEnuZCPTxdv6l_YIjBGqCtPGyAwctfpOUwn7ycbcKQXsWNEGIOeVjg>
    <xme:KEnuZA90JpU9Wyt89_yWcQcKYwP0XHOO2PDjMs17IhihdsusGPRfsVxPTMM9EC6Zg
    d5IPHIPc2OpoJoQNNU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudefiedgudegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedf
    tehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrf
    grthhtvghrnhepgfekueelgeeigefhudduledtkeefffejueelheelfedutedttdfgveeu
    feefieegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:KEnuZJQ82QT57PKuX2SdI3EfjB3QbPj4h5CkM6HEX0-RwBoJKSH3GQ>
    <xmx:KEnuZCsvP7JFkTeOMbU4xtZxFjSDHwJ6RJBS-7ADa6d6EANE-0apdg>
    <xmx:KEnuZKd7L6s-PqctnEtWkMmj_2AuZRWEJQzEUCwrgzziB3gWD06VAw>
    <xmx:KUnuZJ5HL-cM-h_FNttOYmH0IKl7721Qjfp3BLOg7CoNgeHZWYzrnw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 58756B60089; Tue, 29 Aug 2023 15:38:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-701-g9b2f44d3ee-fm-20230823.001-g9b2f44d3
Mime-Version: 1.0
Message-Id: <12206f61-e98f-4d32-859b-92d7bf5adf26@app.fastmail.com>
In-Reply-To: <0702ec24-4ca2-817f-0d71-132fb3b67aa0@huawei.com>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
 <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
 <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
 <20230821102632.GA19294@willie-the-truck>
 <9ef5b6c6-64b7-898a-d020-5c6075c6a229@huawei.com>
 <CAMj1kXH5YWZ1i0=1MVo0kaxSbQWFF6QyGvLUv_K5mqApASzy5w@mail.gmail.com>
 <0702ec24-4ca2-817f-0d71-132fb3b67aa0@huawei.com>
Date:   Tue, 29 Aug 2023 15:37:56 -0400
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Weili Qian" <qianweili@huawei.com>,
        "Ard Biesheuvel" <ardb@kernel.org>
Cc:     "Will Deacon" <will@kernel.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, shenyang39@huawei.com,
        liulongfang@huawei.com
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox configuration at
 one time
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 24, 2023, at 23:07, Weili Qian wrote:
> On 2023/8/21 22:36, Ard Biesheuvel wrote:
>> On Mon, 21 Aug 2023 at 14:45, Weili Qian <qianweili@huawei.com> wrote:

>>>                      : "Q" (*((char *)buffer))
>>=20
>> This constraint describes the first byte of buffer, which might cause
>> problems because the asm reads the entire buffer not just the first
>> byte.
> I don't understand why constraint describes the first byte of=20
> buffer,and the compilation result seems to be ok.
>
>  1811     1afc:       a9400a61        ldp     x1, x2, [x19]
>  1812     1b00:       a9000801        stp     x1, x2, [x0]
>  1813     1b04:       d50332bf        dmb     oshst
> Maybe I'm wrong about 'Q', could you explain it or where can I learn=20
> more about this?

The "Q" is not the problem here, it's the cast to (char *), which
tells the compiler that only the first byte is used here, and
allows it to not actually store the rest of the buffer into
memory.

It's not a problem on the __iomem pointer side, since gcc never
accesses those directly, and for the version taking a __u128 literal
or two __u64 registers it is also ok.

>>>         unsigned long tmp0 =3D 0, tmp1 =3D 0;
>>>
>>>         asm volatile("ldp %0, %1, %3\n"
>>>                      "stp %0, %1, %2\n"
>>>                      "dmb oshst\n"
>>=20
>> Is this the right barrier for a read?
> Should be "dmb oshld\n".

As I said, this needs to be __io_ar(), which might be
defined in a different way.

>>=20
>> Have you tried using __uint128_t accesses instead?
>>=20
>> E.g., something like
>>=20
>> static void qm_write128(void __iomem *addr, const void *buffer)
>> {
>>     volatile __uint128_t *dst =3D (volatile __uint128_t __force *)add=
r;
>>     const __uint128_t *src __aligned(1) =3D buffer;
>>=20
>>     WRITE_ONCE(*dst, *src);
>>     dma_wmb();
>> }
>>=20
>> should produce the right instruction sequence, and works on all
>> architectures that have CONFIG_ARCH_SUPPORTS_INT128=3Dy
>>=20
>
> I tried this, but WRITE_ONCE does not support type __uint128_t.
> ->WRITE_ONCE
>  ->compiletime_assert_rwonce_type
>   ->compiletime_assert(__native_word(t) || sizeof(t) =3D=3D sizeof(lon=
g long),	\
> 		"Unsupported access size for {READ,WRITE}_ONCE().")

On top of that, WRITE_ONCE() does not guarantee atomicity, and
dma_wmb() might not be the correct barrier.

> So can we define generic IO helpers based on patchset
> https://lore.kernel.org/all/20180124090519.6680-4-ynorov@caviumnetwork=
s.com/
> Part of the implementation is as follows=EF=BC=9A
>
> add writeo() in include/asm-generic/io.h
>
> #ifdef CONFIG_ARCH_SUPPORTS_INT128
> #ifndef writeo
> #define writeo writeo
> static inline void writeo(__uint128_t value, volatile void __iomem=20
> *addr)
> {
> 	__io_bw();
> 	__raw_writeo((__uint128_t __force)__cpu_to_le128(value), addr);=20
> //__cpu_to_le128 will implement.
> 	__io_aw();
> }
> #endif
> #endif /* CONFIG_ARCH_SUPPORTS_INT128 */

Right, this is fairly close to what we need. The 'o' notation
might be slightly controversial, which is why I suggested
definining only iowrite128() to avoid having to agree on
the correct letter for 16-byte stores.

> in arch/arm64/include/asm/io.h
>
> #ifdef CONFIG_ARCH_SUPPORTS_INT128
> #define __raw_writeo __raw_writeo
> static __always_inline void  __raw_writeo(__uint128_t val, volatile=20
> void __iomem *addr)
> {
> 	u64 hi, lo;
>
> 	lo =3D (u64)val;
> 	hi =3D (u64)(val >> 64);
>
> 	asm volatile ("stp %x0, %x1, [%2]\n" :: "rZ"(lo), "rZ"(hi), "r"(addr)=
);
> }
> #endif /* CONFIG_ARCH_SUPPORTS_INT128 */

This definition looks fine.

> And add io{read|write}128bits in include/linux/io-64-nonatomic-{hi-lo,=
lo-hi}.h.
> static inline void lo_hi_writeo(__uint128_t val, volatile void __iomem=
 *addr)
> {
> 	writeq(val, addr);
> 	writeq(val >> 64, addr);
> }

This also looks fine.=20

      Arnd
