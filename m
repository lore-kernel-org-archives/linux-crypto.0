Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F636CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 14:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF59120659
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 14:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=temperror (0-bit key) header.d=phytec.de header.i=@phytec.de header.b="KtVtnMwZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfJUOnV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 10:43:21 -0400
Received: from mickerik.phytec.de ([195.145.39.210]:51422 "EHLO
        mickerik.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfJUOnV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 10:43:21 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 10:43:21 EDT
DKIM-Signature: v=1; a=rsa-sha256; d=phytec.de; s=a1; c=relaxed/simple;
        q=dns/txt; i=@phytec.de; t=1571668084; x=1574260084;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/C2547h8FH/9AUJSr3wxTE+CTEe9v03CyHuI44s0KHo=;
        b=KtVtnMwZqLnuPegFQur0I6bErgnp4ZIYFmk34Ls9QzHGPBne6egsDXX7IrN0gpCF
        wougE3MsB9NgMPEcUSRamFSRiVUTAG2OLfB6mlOKxQ38dsTi6f7PAwsHN6X5si+d
        2wTOSYou7FBwr9RsHEOC2mDeKJwzmI7J9M0Hw/I2H5c=;
X-AuditID: c39127d2-df9ff7000000408f-74-5dadc0735781
Received: from idefix.phytec.de (Unknown_Domain [172.16.0.10])
        by mickerik.phytec.de (PHYTEC Mail Gateway) with SMTP id E7.97.16527.370CDAD5; Mon, 21 Oct 2019 16:28:03 +0200 (CEST)
Received: from [172.16.20.247] ([172.16.20.247])
          by idefix.phytec.de (IBM Domino Release 9.0.1FP7)
          with ESMTP id 2019102116280399-141259 ;
          Mon, 21 Oct 2019 16:28:03 +0200 
From:   =?UTF-8?Q?Stefan_M=c3=bcller-Klieser?= 
        <s.mueller-klieser@phytec.de>
Subject: CAAM hw key support status
To:     franck.lenormand@nxp.com
Cc:     horia.geanta@nxp.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org
Message-ID: <2171b6f9-8e80-8f79-fffb-5a5b641ad196@phytec.de>
Date:   Mon, 21 Oct 2019 16:28:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 21.10.2019 16:28:03,
        Serialize by Router on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 21.10.2019 16:28:04,
        Serialize complete at 21.10.2019 16:28:04
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWyRoCBS7fkwNpYg5YJXBZNq98zW3w4f5jJ
        4v69n0wWH3oesTmweGx8t4PJ4/MmuQCmKC6blNSczLLUIn27BK6Mx9vfsxesZqrYP2EFSwPj
        e8YuRk4OCQETiXsrlrN1MXJxCAlsY5T4Mv0AI4RzhlHiZPN5NpAqNgEviXvbG5lAbGEBZYlz
        F38xdzFycIgIyEgseWEPEmYWiJX4uOUkWDmvgI3E98WrmUFsFgFViW9fP4AtExWIkHi+/QYj
        RI2gxMmZT1hAdkkINDJJfF+wjBniIiGJ04vPMkMMlZfY/nYOlG0mMW/zQyhbXOLWk/lMExgF
        ZiGZNQtJyywkLbOQtCxgZFnFKJSbmZydWpSZrVeQUVmSmqyXkrqJERi8hyeqX9rB2DfH4xAj
        EwfjIUYJDmYlEd47BmtjhXhTEiurUovy44tKc1KLDzFKc7AoifNu4C0JExJITyxJzU5NLUgt
        gskycXBKNTCWVJ592H1J+r+f3YbuqF/hgmobPgpOvrl9UdIqZSW/uZEBrxTLVin8T9oYZxoZ
        aPdy3U7nxStjTy7/3vb48HTumBNvG2a2em4X3dl2bsZux4kcAVvtTb4n58XImB1ZplN42P1p
        CMdf2Xc7zBtTrgTMOFxx0O158+UF2Wc+v4lS8ZnG6BQ9Y6qyEktxRqKhFnNRcSIAjhkQ+UwC
        AAA=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Franck,

you sent an RFC to the linux-security-module list:

March 1, 2019, 4:09 p.m. UTC
[RFC,0/2] Create CAAM HW key in linux keyring and use in dmcrypt
https://patchwork.kernel.org/cover/10835635/

Is there any update on this work? How do you want to move forward?

Regards, Stefan
