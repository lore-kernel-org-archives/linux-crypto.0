Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DF7C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 15:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384035AbiDUPRD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355292AbiDUPRC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 11:17:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05921433AA;
        Thu, 21 Apr 2022 08:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9506661AC3;
        Thu, 21 Apr 2022 15:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99E1C385A5;
        Thu, 21 Apr 2022 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650554052;
        bh=I0zUItcOxFNNsLtXno+sh+nNc68LyirhSdAYTIDEIE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dtfFZhaT2VSG7B3vpDVhu7DPaIcToxTO1AtvXVDAGmpgAmGXqG9futEtSoU1F0n6K
         G/BN+b9TTS/Ei9x6W3lEDVMn5SKQTkrDyDapLXHGsTlaBxcLBROJTp0knNpj+KjeB6
         LSqyFbhB4mNlZ3vLZCM8Re2ziShdCIQJmNJBV+/ajSjXCAnHAYyQCIupScTK9hGwBg
         nE3qt0w/WH/64L0SHsy2jfnoQ7wS6TjwBj3BDBaMpI/KK8gvV5spcs7y1FPO5cfrnh
         9ePR+JUJosdgR3tNrQwaIGUX/tpr6Mtd9ABj7ktTp1WPI7VVYXR2AKHQNf2Hby2qaJ
         8cqWqzvjJTP3Q==
Date:   Thu, 21 Apr 2022 18:12:56 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     =?us-ascii?B?PT9VVEYtOD9xP01pY2thPUMzPUFCbD0yMFNhbGE9QzM9QkNuPz0=?= 
        <mic@digikod.net>, David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Snowberg <eric.snowberg@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        =?us-ascii?B?PT9VVEYtOD9xP01pY2thPUMzPUFCbD0yMFNhbGE9QzM9QkNuPz0=?= 
        <mic@linux.microsoft.com>, Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v7 3/5] certs: Make blacklist_vet_description() more
 strict
Message-ID: <YmF0eAh7dYmtLDVx@kernel.org>
References: <20210312171232.2681989-4-mic@digikod.net>
 <20210312171232.2681989-1-mic@digikod.net>
 <648218.1650450548@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <648218.1650450548@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 20, 2022 at 11:29:08AM +0100, David Howells wrote:
> Mickaël Salaün <mic@digikod.net> wrote:
> 
> > +	/* The following algorithm only works if prefix lengths match. */
> > +	BUILD_BUG_ON(sizeof(tbs_prefix) != sizeof(bin_prefix));
> > +	prefix_len = sizeof(tbs_prefix) - 1;
> > +	for (i = 0; *desc; desc++, i++) {
> > +		if (*desc == ':') {
> > +			if (tbs_step == prefix_len)
> > +				goto found_colon;
> > +			if (bin_step == prefix_len)
> > +				goto found_colon;
> > +			return -EINVAL;
> > +		}
> > +		if (i >= prefix_len)
> > +			return -EINVAL;
> > +		if (*desc == tbs_prefix[i])
> > +			tbs_step++;
> > +		if (*desc == bin_prefix[i])
> > +			bin_step++;
> > +	}
> 
> I wonder if:
> 
> 	static const char tbs_prefix[] = "tbs:";
> 	static const char bin_prefix[] = "bin:";
> 
> 	if (strncmp(desc, tbs_prefix, sizeof(tbs_prefix) - 1) == 0 ||
> 	    strncmp(desc, bin_prefix, sizeof(bin_prefix) - 1) == 0)
> 		goto found_colon;
> 
> might be better.
> 
> David

I think it'd be. 

BR, Jarkko
