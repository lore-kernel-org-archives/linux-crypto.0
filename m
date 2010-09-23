From: Tirumala Marri <tmarri@apm.com>
Subject: RE: [PATCH v1 1/4] PPC4xx: Generalizing ADMA driver modifications
Date: Thu, 23 Sep 2010 15:44:41 -0700
Message-ID: <fe45b421a909d749a6cf583426a1ce6d@mail.gmail.com>
References: <1285279839-16588-1-git-send-email-tmarri@apm.com> <4C9BD6DC.3070707@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-raid@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, yur@emcraft.com,
	herbert@gondor.hengli.com.au
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:45221 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752016Ab0IWWon (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Sep 2010 18:44:43 -0400
In-Reply-To: <4C9BD6DC.3070707@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>
> Did you look at this changelog before sending?  It just deletes 4000
> lines of code??
[Marri] The reason I have to send it in different file is the size of the
patch.
There seem to be issue with patch sizes 200k or more.
