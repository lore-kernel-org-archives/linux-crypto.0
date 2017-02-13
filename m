From: Jon Mason <jon.mason@broadcom.com>
Subject: Re: [PATCH v4 0/3] Add Broadcom SPU Crypto Driver
Date: Mon, 13 Feb 2017 10:11:40 -0500
Message-ID: <CAC3K-4orafSfvi-1E5+sS_c7_2nbU3tzk-QMaJg555q40a-GGg@mail.gmail.com>
References: <1486144534-44887-1-git-send-email-rob.rice@broadcom.com>
 <20170211105404.GF855@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, Rob Rice <rob.rice@broadcom.com>,
 Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>,
 Rob Herring <robh+dt@kernel.org>,
 BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
 linux-crypto@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170211105404.GF855@gondor.apana.org.au>
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

On Sat, Feb 11, 2017 at 5:54 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Feb 03, 2017 at 12:55:31PM -0500, Rob Rice wrote:
>> Changes in v4:
>> - Added Rob Herring's Acked-by to patch 1/3 for bindings doc
>> - In response to Herbert's comment, in ahash_export() and
>>   ahash_import(), only copy the hash state, not state params
>>   related to cipher or aead algos.
>> - Noticed that hmac_offset in iproc_reqctx_s and spu_hash_params
>>   wasn't really used. So removed.
>
> Patches 1-2 applied.  Thanks.

Thanks Herbert!

Florian, could you please include patch #3 in your DT branch?

Thanks,
Jon

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
