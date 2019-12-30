Return-Path: <SRS0=xlaa=2U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5101C2D0C2
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 10:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E0420748
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Dec 2019 10:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.com header.i=@cs.com header.b="ICWH2MJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfL3KKF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 05:10:05 -0500
Received: from sonic306-1.consmr.mail.bf2.yahoo.com ([74.6.132.40]:36960 "EHLO
        sonic306-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727320AbfL3KKE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 05:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.com; s=a2048; t=1577700603; bh=q1w9EIIAcq7yIfhtNHcnLWOwUI8Ubn622y7vdguJPZM=; h=Subject:From:To:Date:References:From:Subject; b=ICWH2MJrkPu/a8WZTJMfVYsBWLr3l8KekcG4//OC9dt2eNsIHw5CM8Xp2w2BQ/CvksNSwIUvuxgWO1FZ4RZDKXg2RobOO2BUMknbl17m4kN0YsCr2eZwZJNQJW/4cCW6VvnZi1coiTsgLPzwUyiULhziYzCZaeoXU379ha3eqLoVR1n8qVT0bNO5ZbiI/qhFrs9rBjZQx2LQdbM8uaY+TfNO93NvcuRBZ1jDWKOwJp+D3ZBc2kuzKqVFwOK74Q3iU9hgDVg3XLHlEfhGQbfS1BhjR9K6fZoYfh5Ev7j1fjDl0BCCorRvIN1/jS4EHZJStAKpgzu0UEuWhxg2yAbpFg==
X-YMail-OSG: SzFCFHwVM1nS5ZzLIpf91oBVVU2eXYuOGQzinDaRYKQS8xN.l3Qcrqjs5GGOgh_
 hry1_55.0pNmHHXdzwfkeXlaatc.D1ERoJTtM22nFCIpyQbs.WRm4Kwe06PMJ0FkKE53h_2Fsr2L
 ALIsrbXZvzP1AIkLuAx0hCFDOV03cqDLdBkvt_4_KlREl40a.s_SXONxVDvgh1PhCvEzFSq5pNUh
 HpyvbIUcrUgKM0n.AOIDZSVWbfLycPyXlzy4hx4h0cRrjbG9mUCl3wD0BKPZzRAK89Ywtfiwkqtj
 G0fLuNHSfQHb.biKVlVHdRXA.pjXr2hqU8ChpP4JaDqQBjNtVwNrfbaeNWfnkhbGuHfHcQmmUWwC
 cboIFcAoC1a078gozoxZDBMx0b2XithbUr5Cf02HkdOWm4F7F.VJjeKgccjzvTrW5yXIl.Q6PStp
 BxQoSdK.7x7NxT8gxkgNLI8c1Qd4yx3.CqJEol4.aH9xo5DDSzliSLHgwtegS.wHn8LVNRgN2MPA
 JOdm48rCIXrPA_ci0N2Q_dk4Ms._sLVaRgJdN1PGhXdEX0_8AoTeu.pmKj4gkRHLp1.wYzciEg4E
 1nNBgYeJCTa04jI3ymVmswz0DOAtxppeEDNPz8yP5155xw4vfSYSsMXnPIwpIZgqyIYEgD6B_2Kc
 8oiJCqocWZJ29GKnMmFkoB1VM.WeK2WQziFK2TMFXk5ZlyKGv4sKp9Vn_onGl9D0D0EeY3EbsvaD
 NFI3xwvyyiJmPnZncqSs6hSRg8I8U5lF.s9G6drg3l4Mxkfr7dyXd3Ke6QIPY9d0lp5yNvsynw4_
 zzaFTfOVPthp.iIt.x88aK5ma8aPJiCc_Q.GwwCzG0q4N.z.LrnSLTaUE5bdYGtQ1_vGD5lptUT6
 qOkQf3i.J5cNgpgPcSZR59DLmBPBy5VhL7es8ZClBE2QflkfC7PiIn7.OJw0CZEMDIsBfA4FcjLV
 _lbqPnfTDw0rfZ5XrK._PseS2hjpe_jsbCrqfWYfVEbXWsyx4XaXhBlYGuEKt.f2b3f_jNV.g9pc
 NCAf6nMRwwazIfJbW5Iz1m6.wg8ZRKFXKx7BkyOHmVFJvwS._Bj4VddT_TTsSSy3Z4zBoi9vvKmw
 xBKO3wJ0VXD7mFAKO5my68lRJYNbs5L.dsPQrstpCeWT00fXz.9JbtyPt0D65vKMMzjCJ_s8xUNL
 Fhfd39YEspQAO8ScCj4ihY0GKgYj3DEhvPUMaVkDWJa1uu7uSgaB9_mrmGmUCOHBJjZZhaii95mq
 L97sVYwFWz6Y1Lock7p0Mlk_MzUyGPP18c_f2cp.3W0c6kPpJLocGKFFhFC0MfBlIB3iC_885wR.
 mXvAckVQABQG4sTz6youDO68GBC9R
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Mon, 30 Dec 2019 10:10:03 +0000
Received: by smtp407.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID f94e7fa2f2d01fc30b80336b9416a5e9;
          Mon, 30 Dec 2019 10:10:02 +0000 (UTC)
Message-ID: <6c4fbd8240af542f2c5e26e990825f1232009aaf.camel@cs.com>
Subject: Internal crypto test fail: changed 'req->iv'
From:   Richard van Schagen <vschagen@cs.com>
To:     linux-crypto@vger.kernel.org
Date:   Mon, 30 Dec 2019 18:09:50 +0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <6c4fbd8240af542f2c5e26e990825f1232009aaf.camel.ref@cs.com>
X-Mailer: WebService/1.1.14873 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I am writing a module for the EIP93 crypto engine. From what I have
been reading on this mailing list, the driver should return the updated
IV in order for the caller to “resume” or “continue” with this IV in
another call.

A code-snippet:

int ivsize = crypto_skcipher_ivsize(skcipher);

If (ivsize)
	memcpy(req->iv, rctx->lastiv, ivsize);

Where rctx->lastiv was read from the hardware itself.

The fail message I am getting is:
[   57.290000] alg: skcipher: changed 'req->iv'
[   57.370000] alg: skcipher: eip93-cbc-aes encryption co
rrupted request struct on test vector 0, cfg="in-place"
[   57.380000] alg: skcipher: changed 'req->iv'
[   57.460000] alg: skcipher: eip93-ctr-aes encryption corrupted
request struct on test vector 0, cfg="in-place"
[   57.470000] alg: skcipher: changed 'req->iv'
[   57.560000] alg: skcipher: eip93-rfc3686(ctr)-aes encryption
corrupted request struct on test vector 0, cfg="in-place"
[   57.570000] alg: skcipher: changed 'req->iv’

Where/How should I return the new/updated IV ?

Thanks,

Richard van Schagen

