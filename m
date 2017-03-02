From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Problem with RSA test from testmgr
Date: Thu, 2 Mar 2017 08:30:10 -0800
Message-ID: <4adef3de-a376-5827-37cc-af45cd683293@intel.com>
References: <20170228155953.GA1732@Red>
 <9482066.IEBbAWS9B8@positron.chronox.de> <20170301120414.GA18217@Red>
 <45107561.YcGaMWr4ZQ@tauon.atsec.com> <20170302062158.GA9242@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:50961 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751531AbdCBQds (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 11:33:48 -0500
In-Reply-To: <20170302062158.GA9242@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/01/2017 10:21 PM, Corentin Labbe wrote:
> I am finishing a patch that made testmgr test both (padded and unpadded).

Even if you patch the test vectors there is no guarantee that a user
of the API will always have the plain text padded.
It can be anything between 1 and the key size.
This needs to be the driver who adds padding if needed.
See how other implementations handle it.
Thanks,
-- 
Tadeusz
