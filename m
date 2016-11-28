From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: vmx - rebuild generated asm when target changes
Date: Mon, 28 Nov 2016 13:51:36 +0530
Message-ID: <20161128082136.GD29256@naverao1-tp.localdomain>
References: <20161126042459.1964-1-npiggin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Leonidas S . Barbosa" <leosilva@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
To: Nicholas Piggin <npiggin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754142AbcK1IVs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 03:21:48 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAS8Ipg1001387
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 03:21:47 -0500
Received: from e28smtp02.in.ibm.com (e28smtp02.in.ibm.com [125.16.236.2])
        by mx0b-001b2d01.pphosted.com with ESMTP id 270exbdexd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 03:21:47 -0500
Received: from localhost
        by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Mon, 28 Nov 2016 13:51:43 +0530
Received: from d28relay09.in.ibm.com (d28relay09.in.ibm.com [9.184.220.160])
        by d28dlp03.in.ibm.com (Postfix) with ESMTP id D0ACA1258061
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 13:52:43 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
        by d28relay09.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uAS8Lf0n27525316
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 13:51:41 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
        by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uAS8Lcvi017008
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 13:51:40 +0530
Content-Disposition: inline
In-Reply-To: <20161126042459.1964-1-npiggin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016/11/26 03:24PM, Nicholas Piggin wrote:
> Switching from big endian to little endian can fail to regenerate
> the crypto assembly properly. Switch to using standard form of
> kbuild dependency checking (i.e., use FORCE and if_changed).
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Hi Nick,
A similar patch is already in:
https://mid.mail-archive.com/linux-crypto@vger.kernel.org/msg21855.html

- Naveen
