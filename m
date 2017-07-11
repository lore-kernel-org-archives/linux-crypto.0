From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: HELP writing crypto driver for HW with blocksize hash
Date: Tue, 11 Jul 2017 13:30:44 +0300
Message-ID: <CAOtvUMf=CKjZPOi5m7DMzN10Ytd81v_qK3n6aTaCqP1gRMQ6Pg@mail.gmail.com>
References: <CGME20170711075213eucas1p1816f12edc165dfe05cb791b155e6f658@eucas1p1.samsung.com>
 <09fb0bef-ee22-edff-c651-a81e3ee6a2ae@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, linux-newbie@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-newbie-owner@vger.kernel.org>
In-Reply-To: <09fb0bef-ee22-edff-c651-a81e3ee6a2ae@partner.samsung.com>
Sender: linux-newbie-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 11, 2017 at 10:52 AM, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Hi,
>
> I am writing crypto driver for hash MD5/SHA1/SHA256 on Exynos 4412,
> and I am facing some (minor?) difficulties.
>
> In old days, hadware (HW) can only do basic hash block operation,
> so at the end it needed to finalize hash, and driver need to
> write some bits into buffer to get message hash. Time passes,
> and hardware (HW) was designed with improved cappabilities,
> so it can add itself bits after message and calculate hash,
> it can stop then export state, import and resume,
> but ... it can not process null-length (or zero-length) ending.
> So there is no more final method.
>
> It must be feeded with at least one message byte to produce hash.
>
> One more constrain is to process data in constant-sized chunks,
> here it is 64 bytes, the same as for AES block,
> i.e. it cannot stop and export state while in middle of block,
> example - if we feed 16 bytes, we must then feed 48 bytes
> to stop, but ideally we should feed it always 64 bytes.


>
> Some crypto drivers with similar problem(s):
>
> omap-sham.c - no final and blocksize needed,
> broadcom bcm/spu.c - no final,
> ccp/ccp-crypto-sha.c - no final,
> nx/nx-sha256.c - blocksize needed,
>
> One more thing - in algorithm description for methods:
> final, finup, update, digest, export, import
> there is note that finup is for those hardware
> that cannot do final, but again,
>
> it looks like crypto framework is ignoring that and every finup
> is translated into "update, final".
>
> HW driver will do opposite - it will translate final into finup.
>
> From this follows that for every such HW crypto drivers authors
> duplicate code for keeping at least blocksize cache of message.
>
> One more point - use of block size in algo structure.
> It is for informing framework about HW limitation,
> but seems to be ignored again...
>
> Any suggestions ?
>
> Can i keep some bytes unfeeded from ahash_request
> and return -EINPROGRESS ?
> Should i set timer and copy rest bytes after some timeout,
> where no more requests are incoming ? Or not ? cause it is
> async mode ?
> can i wait for more requests for processing waiting one ?
>

Your two constraints are actually inter-related -

If you can only feed the HW a constant size chunk, than indeed need to
keey bytes fed
to the driver the are below the chunk size in a software buffer, but
than you need the final()
method to feed these bytes (padded as needed) to the HW if they are
the last bytes

Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
--
To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs
