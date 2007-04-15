From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Sun, 15 Apr 2007 21:40:56 +0530
Message-ID: <a781481a0704150910t8856387uf8a7b1aab860944a@mail.gmail.com>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
	 <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
	 <20070414194434.GA18988@halcrow.us>
	 <a781481a0704150406y7d256e8ft47e7ce8d71877f8d@mail.gmail.com>
	 <a781481a0704150731w68933d2cr162437fe17b568b4@mail.gmail.com>
	 <20070415153147.GD18988@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: "Michael Halcrow" <mike@halcrow.us>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:26277 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbXDOQK6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Apr 2007 12:10:58 -0400
Received: by ug-out-1314.google.com with SMTP id 44so916244uga
        for <linux-crypto@vger.kernel.org>; Sun, 15 Apr 2007 09:10:57 -0700 (PDT)
In-Reply-To: <20070415153147.GD18988@halcrow.us>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Mike,

On 4/15/07, Michael Halcrow <mike@halcrow.us> wrote:
> On Sun, Apr 15, 2007 at 08:01:24PM +0530, Satyam Sharma wrote:
> > I might be answering myself here, but clearly, removing the
> > whitelist does not seem possible given the PGP-message-framework
> > eCryptfs was designed in.
>
> The whole cipher code thing is just posturing. eCryptfs could just as
> easily write the cipher string out to the metadata and then pass that
> verbatim to the crypto API on sys_open(). There's no hard-and-fast
> rule that dictates that eCryptfs absolutely has to write anything out
> to the metadata in any particular format.

Ok, in that case, I would really suggest that you get rid of the
cipher-tags / whitelist business completely ... doing so does provide
all those benefits I just mentioned previously.

Cheers,
Satyam
