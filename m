Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52406C04EB5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 15:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1C4214AF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 15:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvv/L02g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgBGPC6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 10:02:58 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:33347 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGPC6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 10:02:58 -0500
Received: by mail-qv1-f66.google.com with SMTP id z3so1144904qvn.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2020 07:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lw2eBX37HV3I+iZgkoQ/m7G3lORVIcniU/MJl17AlpI=;
        b=lvv/L02gCUff+GhyXrjk31y//gR/tCCtpTgRB2hQ/Qk/Dem+KYvZhDqU5E3rcIzuw+
         UTHe9zuhPXVRiwFt9mtusAQXL3Ud97CwtrQwf28YBpZQJUIx+xQnPbiIRmgYgbt+CoX6
         146TPVccNr+VPjcyvR/NcnKZyh4pYZLzW9uwWCQPUnFq7lQo4cFwTye3eY65zOYeIOyA
         Rqj4sHGXYCwPiMl1eGGNdYWp60jOOzHswt5wZTuRuOMRPfNLzhWNL1KTSMkzjUsLKSja
         FpxzitCZ3GqojK38kfZxjQWrjbcDsa9axZTGLOwjuJRPevyGBGcXXcPapsH2D77+b/cI
         pDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lw2eBX37HV3I+iZgkoQ/m7G3lORVIcniU/MJl17AlpI=;
        b=jDEkbXRQ+55IxeRSNvDz7Z7Fgu9E54nqMUsdTX2s0IniDjeWwiaaB8yBdkTVESRfTe
         Hu/QzDamJ/8w0wthMt5nS8jNB41OnCNMsew+/EqthfKzY7hROXGE7DOLYwlKXRpWP834
         kPrZVwX7gC8e0qCCwfYXf0uqUfZdzjKLTST/jvakRtGiP7zjJsWSOXGPS5iy3HUr2EHS
         5jpkEci+bAgdwXETZObe+F18KnHaFDvPv+VTtdPEBQDuuNgh14n5ileXcW/FjGaC3IvW
         mDU7F0Rm49AQLlqgkpDkogcw5hgCMSuusrUYQ8i639w5esdhFKv0xUpoZlyOX9O+Au9H
         QkoA==
X-Gm-Message-State: APjAAAWSblMypx/0p1WjS7wEU5hFtIqzkbYexnvFJIz+3sHj/MjK5Ppj
        Ya2rwbpYJM5dGHAZoa+jBrrLrfZN
X-Google-Smtp-Source: APXvYqx5hbrs4heMJaTMV251b3Zw/7a3b9dh1qPIsaDAsvhkYPd7T9kizl8Qu0ojtwmOUYw9M/Lnig==
X-Received: by 2002:a05:6214:b23:: with SMTP id w3mr7325443qvj.181.1581087776424;
        Fri, 07 Feb 2020 07:02:56 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id c10sm420740qkm.56.2020.02.07.07.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:02:55 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v5 0/3] crypto: qce driver fixes for gcm
Date:   Fri,  7 Feb 2020 12:02:24 -0300
Message-Id: <20200207150227.31014-1-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I've made enough mistakes in this series, I'll just start over.  It's
been hard for me not to be able to run test this in master, and have to
go back and forth between it and 4.19; that's why I have messed up so
many times.  I apologize for the noise again.

If you've read the cover letter from v1 and v2, there's not anything too
relevant that I'm changing here.

---

I've finally managed to get gcm(aes) working with the qce crypto engine.

These first patch fixes a bug where the gcm authentication tag was being
overwritten during gcm decryption, because it was passed in the same sgl
buffer as the crypto payload.  The qce driver appends some private state
buffer to the request destination sgl, but it was not checking the
length of the sgl being passed.

The second patch works around a problem, which I frankly can't pinpoint
what exactly is the cause, but after some help from Ard Biesheuvel, I
think it is related to DMA.  When gcm sends a request in
crypto_gcm_setkey, it stores the hash (the crypto payload) and the iv in
the same data struct.  When the driver updates the IV, then the payload
gets overwritten with the unencrypted data, or all zeroes, it may be a
coincidence.

However, it works if I pass the request down to the fallback driver--it
is used by the driver to accept 192-bit-key requests.  All I had to do
was setup the fallback regardless of key size, and then check the
payload length along with the keysize to pass the request to the
fallback.  This turns out to enhance performance, because of the
avoided latency that comes with using the hardware.

I've started with checking for a single 16-byte AES block, and that is
enough to make gcm work.  Next thing I've done was to tune the request
size for performance.  What got me started into looking at the qce
driver was reports of it being detrimental to VPN speed, by the way.
I've tested this win an Asus RT-AC58U, but the slow VPN reports[1] have
more devices affected.  Access to the device was kindly provided by
@simsasss.

I've added a 768-byte block size to tcrypt to get some measurements to
come up with an optimal threshold to transition from software to
hardware, and encountered another bug in the qce driver: it apparently
cannot handle aes-xts requests that are greater than 512 bytes, but not
a multiple of it.  It failed with 768, 1280; XTS is usually used with a
512-byte sector (or a multiple of it), so I'm concluding that is the
cause of failure.

With that fixed, I added a module parameter to set the maximum request
size that will be handled by the software fallback cipher and made some
speed measurements using tcrypt to come up with an optimum value.

I've documented this briefly in the parameter description, pointing out
that gcm will not work if you set it to 0, and in better detail in the
Kconfig help.

TLDR: In the worst (where the hardware is slowest) case, hardware and
software speed match at around 768 bytes, but I lowered the threshold to
512 to benefit the CPU offload.

Here's a sample comparing three runs, using the proposed driver, varying
the aes_sw_max_len parameter: 1st run will always use fallback, second
run will use the default fallback for len <= 512, and third run will
never use the fallback.

testing speed of async cbc(aes) (cbc-aes-qce) encryption
------------------      ----------   ----------    ----------
aes_sw_max_len              32,768          512             0
------------------      ----------   ----------    ----------
128 bit   16 bytes       8,081,136    5,614,448       430,416
128 bit   64 bytes      13,152,768   13,205,952     1,745,088
128 bit  256 bytes      16,094,464   16,101,120     6,969,600
128 bit  512 bytes      16,701,440   16,705,024    12,866,048
128 bit  768 bytes      16,883,712   13,192,704    15,186,432
128 bit 1024 bytes      17,036,288   17,149,952    19,716,096
128 bit 2048 bytes      17,108,992   30,842,880    32,868,352
128 bit 4096 bytes      17,203,200   44,929,024    49,655,808
128 bit 8192 bytes      17,219,584   58,966,016    74,186,752
256 bit   16 bytes       6,962,432    1,943,616       419,088
256 bit   64 bytes      10,485,568   10,421,952     1,681,536
256 bit  256 bytes      12,211,712   12,160,000     6,701,312
256 bit  512 bytes      12,499,456   12,584,448     9,882,112
256 bit  768 bytes      12,622,080   12,550,656    14,701,824
256 bit 1024 bytes      12,750,848   16,079,872    19,585,024
256 bit 2048 bytes      12,812,288   28,293,120    27,693,056
256 bit 4096 bytes      12,939,264   34,234,368    44,142,592
256 bit 8192 bytes      12,845,056   50,274,304    63,520,768

The numbers vary from run to run, sometimes greatly.

I've tried running the same tests with the arm-neon drivers, but the
results don't change with any cipher mode, so I'm assuming the fallback
is always aes-generic.

I've made the measurements using an Asus RT-AC58U only, so I don't know
how other hardware performs, but the user can always override the
parameter, or even its default value.

[1] https://forum.openwrt.org/t/ipsec-performance-issue/39690

Eneas U de Queiroz (3):
  crypto: qce - use cryptlen when adding extra sgl
  crypto: qce - use AES fallback for small requests
  crypto: qce - handle AES-XTS cases that qce fails

 drivers/crypto/Kconfig        | 23 +++++++++++++++++++++++
 drivers/crypto/qce/common.c   |  2 --
 drivers/crypto/qce/common.h   |  3 +++
 drivers/crypto/qce/dma.c      | 11 ++++++-----
 drivers/crypto/qce/dma.h      |  2 +-
 drivers/crypto/qce/skcipher.c | 30 ++++++++++++++++++++----------
 6 files changed, 53 insertions(+), 18 deletions(-)

