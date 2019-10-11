Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94834ECE58D
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 22:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76B0C222C9
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 22:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfJKWew (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 18:34:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfJKWev (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 18:34:51 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AEF0B81F18
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 22:34:51 +0000 (UTC)
Received: by mail-io1-f72.google.com with SMTP id i2so16543597ioo.10
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 15:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=pb2kd2/UeXZLZxX2NPDVZ505qaor0AU6e6HZyZ5Nf/0=;
        b=TcgY5P6Am7cBv9oVRizy7Dxn2JoyOZHj3U5HB/IojaN68UlcxOcmSOAxpXbF6cLCrC
         LKhe/acRlD1fbWYa5sfrQtEgX+SRUN2iwl8V3XxtgFlNVsYD1rqSZ/mWn63hbrkcLSBF
         GaIdRuy3DJyvUrmC3NXU/AEFJiz1lZ4Z3UdNfF8vOu2jfmcuuwJWOh8NJQwyq4uIB2ny
         myQfItzamFomSioXS0DyBoCziLHYNI7yIPL/IPrJYeqmZ3dDokY1ZB+aabHfhkvvuFH2
         JrlcSPqU/ofRr+GdkRwqkstOUyzg2Ue59onzzD/MyxpAiTAWLT2mZ3sSyDMJpCeBXont
         DKlA==
X-Gm-Message-State: APjAAAWXDIzYf6i9Q41IUZFyLSnQRVgZi8sr/i7EuQSgnM39SlbeMYUU
        YG6h94VXPXgpJmOoNPRTlSXjPhU8xh+4Op+5SiwR/nLwjpE506G0t5WyTHz87pb22fxPGs2xrgL
        ZhdPNZTgb1VPDlKhc7DNPZ32b
X-Received: by 2002:a5d:8b12:: with SMTP id k18mr3790078ion.133.1570833291145;
        Fri, 11 Oct 2019 15:34:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwpN+irjTZ41pWeVOF+4kudnO11CT6u7HGkC68Z1Xz7WWUQxPTXop0tLsor9iDJHIHBYs/Qjg==
X-Received: by 2002:a5d:8b12:: with SMTP id k18mr3790056ion.133.1570833290974;
        Fri, 11 Oct 2019 15:34:50 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id u11sm8534708iof.22.2019.10.11.15.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 15:34:50 -0700 (PDT)
Date:   Fri, 11 Oct 2019 15:34:49 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     jarkko.sakkinen@linux.intel.com, dhowells@redhat.com,
        peterhuewe@gmx.de, keyrings@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, jgg@ziepe.ca, arnd@arndb.de,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        linux-kernel@vger.kernel.org, daniel.thompson@linaro.org
Subject: Re: [Patch v7 2/4] KEYS: Use common tpm_buf for trusted and
 asymmetric keys
Message-ID: <20191011223448.7kycskba5mfsbvvw@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Sumit Garg <sumit.garg@linaro.org>,
        jarkko.sakkinen@linux.intel.com, dhowells@redhat.com,
        peterhuewe@gmx.de, keyrings@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, jgg@ziepe.ca, arnd@arndb.de,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com, zohar@linux.ibm.com,
        jmorris@namei.org, serge@hallyn.com, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
References: <1570425935-7435-1-git-send-email-sumit.garg@linaro.org>
 <1570425935-7435-3-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570425935-7435-3-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon Oct 07 19, Sumit Garg wrote:
>Switch to utilize common heap based tpm_buf code for TPM based trusted
>and asymmetric keys rather than using stack based tpm1_buf code. Also,
>remove tpm1_buf code.
>
>Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
>---

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
