Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D18C4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 14:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71576206FA
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 14:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601647471;
	bh=nRsUJILRzB7DvNcjyX0rSrBNDy8ql/F29/KcDQ+iIAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Qop1h2mzUYZ27aim98IQVqq/wdq7u//Rpga/x0UhH/MLO3nGOqLpHTKf2HFksE61z
	 8i7SDjv4QM/QJA2pckKzpmHmk62rMUhOAZW8ZKojfl5FvhQ/Fq3ArtjPr2ND2z5RCM
	 iLqAaigwmePPcNoXfqu9jK/OZSFAVeD/XZUo4+7U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgJBOEa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOEa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 10:04:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17608206CD;
        Fri,  2 Oct 2020 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601647469;
        bh=nRsUJILRzB7DvNcjyX0rSrBNDy8ql/F29/KcDQ+iIAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmECrPZcwXD87uiuzOt1FUO+xaTec5RPtqCpNvOt5JKLUGxq2UM1T3esa1L0HW+ol
         JSMYBkHHm44ytfveBwhm6eGlgk7SvWVUi//4TN3C2TfHEjITW6qvZ4pSXsfRyw3BXb
         LIWnho0K29s1ZNTXKHz5yXYigqZ0P0qGOrwC4jBo=
Date:   Fri, 2 Oct 2020 16:04:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Torsten Duwe <duwe@lst.de>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Message-ID: <20201002140428.GC3475053@kroah.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
 <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 02, 2020 at 01:35:18PM +0000, Van Leeuwen, Pascal wrote:
> ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying, forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **

As per my legal department requests, this is now ignored and deleted on
my system...

Hint, it's not a valid footer for public mailing lists...

greg k-h
