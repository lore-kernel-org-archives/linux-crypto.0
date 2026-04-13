Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2C23E1CF4;
	Mon, 13 Apr 2026 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776094984; cv=none; b=JLiskUJI+/Lj+cQefh/cdh1r8hF0KCTLxW/QvmcZUfnHUOxQaVEG4I6pDCGU5O78oNUE22OUmrQS+ncnseKclk9993pzevFr1eE+ZePC0wbzo30hOv4wOJ+6ULxRXBqb6uiBpIxgJ3XNy10uwBmSwPLKQOnJ4cPiyhS6/33Ptys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776094984; c=relaxed/simple;
	bh=hLsx70sMdcotopqHNsLBc2AEQ5jMSje3hbNi7sVq1k4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=CXQZjwEgQDO0u2EwV65xn8XFTiJPUJmcPHGhTauaJQ3ckXbKG2rx0GxDxQfQ0TRaxB6EdRjRmQgS95vGj7CU2tyNueOwAnD05h5qqqBHCeRKMdU8uWVXSeq02H4P/num1JYR6uYjzYrUKUzpfFn2ZIcfnb26YzvP2iiWVqg4qT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=i/0XCaUe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=O4nJNFeE; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="i/0XCaUe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="O4nJNFeE"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1FC077A0203;
	Mon, 13 Apr 2026 11:43:02 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 11:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776094981;
	 x=1776181381; bh=itBI29KM53gNnSx4gzzoQ/lMfRfee0IQoy4cfLNKkQY=; b=
	i/0XCaUe+HuFkuSAeTltnvXz23Z7f4Ky6hgSqPuqh18Dtj7dY3KRBM4PvfdgxzP2
	eSjGJnxCmsu26cWX+u11qwbX1N9skr8sZmlHmUP/KM2PpD4MTINXrGYPSzo1QBwf
	M+dhJTyNeKAE8qO53TKQWiGjgZ9RANe9bMNBCpCKJj/4ufLlIS3riGnupBG6iDTw
	TD8KQ465JEHBugUWaEaVeK2y8pUr1WuuJ2d6KGwMOYrA7KbKYnd4U2clxaS4RoyX
	w9S22vXM3V+Bqyy2xxtw75DSOz9eudaqTGIMGD2Lc5TejWylFosygTYWQm/FPCrx
	Fwro/nvs9zXF1v+xFtDbfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776094981; x=
	1776181381; bh=itBI29KM53gNnSx4gzzoQ/lMfRfee0IQoy4cfLNKkQY=; b=O
	4nJNFeErlyhJnv1z+v0wzRrMW5OVkxT+dbstjXwD92FtgBfa9tAVTez8YEngDTFj
	W0FT+s/pdPXe8fU06qbPtzmVLh1P4QjRucPQ5GwZW6wVGFO9omqw+dH4Rmt1e8qK
	Jh/YI/tdz5DaIpvuIbp+kD3TQE+g7gcqov/QuMg1vFzqtEJnwpTHQLvlu8vGgVgZ
	7TSDmUomqTTimCR8CX6P56o+z94bNVb4NUN7MuoJzu+2S4VT+u35anz3uznx/GCQ
	zMMlURslh0j1NUnPs07KZZr1TwFyMNz7KgqlZEsVnNX+7CR2nLXv8Fl9qn5QFCEW
	VOnVlWFtbt9RRgq6IS7yA==
X-ME-Sender: <xms:BA_daUXJ1wXgESO_tmaPr1TK5p7rWr7bYPim0NkV6fllQLs8U6Lmtw>
    <xme:BA_daTaE35gUbnIbiuSNrlBtfeHgxjefEsPXuPUfIRGGb8eoYb6Gz0ysGZgZOLPHl
    a_O0PF9WBjeLKtuX4si6vuxNTgecK1mSQrMjJwUdwXgRLoO349c7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkeeifecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepvhhinhgtvghniihordhfrhgrshgtihhnohesrghrmhdrtghomhdprh
    gtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtoheprghn
    ughrvgihkhhnvhhlsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhihrggsihhnihhnrd
    grrdgrsehgmhgrihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhr
    rdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopeguvhihuhhkohhvsehgohhoghhlvg
    drtghomhdprhgtphhtthhopehglhhiuggvrhesghhoohhglhgvrdgtohhmpdhrtghpthht
    ohepkhgrshgrnhdquggvvhesghhoohhglhgvghhrohhuphhsrdgtohhmpdhrtghpthhtoh
    eprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
X-ME-Proxy: <xmx:BA_daUCocpZlIltorJflpCA7RnfCw6aiw8BIuER6-9NkGaN2V1NhPw>
    <xmx:BA_daVBhgYwjFLV7tWGMoOYbGy2XkBb88iVZMkjBvOemP_HJUM_eqQ>
    <xmx:BA_daeZqQJx3hHBZThexkRt0UujaSYgPCPUNm-ZtT6SRlJg3IpypmQ>
    <xmx:BA_daaxz5jg5NybW39G6K-j3gQo5lBYBxUGGzDaKDBRC9GhUSaKmhQ>
    <xmx:BQ_dacXDpBT4-aNUyErPFVpTRK8fRXl_wqPbZ3NEkF0HDLMmg2khQz3P>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2808370006A; Mon, 13 Apr 2026 11:43:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0Zw7CNZgRBF
Date: Mon, 13 Apr 2026 17:42:39 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lukas Wunner" <lukas@wunner.de>,
 "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Ignat Korchagin" <ignat@linux.win>, "Stefan Berger" <stefanb@linux.ibm.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, "Alexander Potapenko" <glider@google.com>,
 "Andrey Konovalov" <andreyknvl@gmail.com>,
 "Dmitry Vyukov" <dvyukov@google.com>,
 "Vincenzo Frascino" <vincenzo.frascino@arm.com>
Message-Id: <05d3e296-1b61-4ab4-9bec-6c11407e6f89@app.fastmail.com>
In-Reply-To: <adZZ70lNnhoDnwok@wunner.de>
References: 
 <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <adY8iUPrnoXDp_-g@ashevche-desk.local> <adZZ70lNnhoDnwok@wunner.de>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Apr 8, 2026, at 15:36, Lukas Wunner wrote:
> On Wed, Apr 08, 2026 at 02:31:21PM +0300, Andy Shevchenko wrote:
>> On Wed, Apr 08, 2026 at 08:15:49AM +0200, Lukas Wunner wrote:
>> > Prevent gcc from going overboard with inlining to unbreak the build.
>> > The maximum inline limit to avoid the error is 101.  Use 100 to get a
>> > nice round number per Andrew's preference.

Have you checked if the total call chain gets a lower stack usage this
way? Usually the high stack usage is a sign of absolutely awful
code generation when the compiler runs into a corner case that
spills variables onto the stack instead of keeping them in registers.

The question is whether the lower inline limit causes the compiler
to not get into this state at all and produce the expected object
code, or if it just ends up producing multiple functions that
stay under the limit individually but have the same problems with
stack usage and performance as before.

I think your patch can be merged either way, but it would be
good to describe what type of problem we are hitting here.
 
>> I think this is not the best solution. We still can refactor the code
>> and avoid being dependant to the (useful) kernel options.
>
> Refactor how?  Mark functions "noinline"?  That may negatively impact
> performance for everyone.

I ran into the same issue last year and worked around it by
turning off kasan for this file, which of course is problematic
for other reasons, and I never submitted my hack for inclusion:

--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -176,6 +176,7 @@ obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
+KASAN_SANITIZE_ecc.o = n
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 
 ecdh_generic-y += ecdh.o

In principle this could be done on a per-function basis.

      Arnd
