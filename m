From: Kevin Hilman <khilman@baylibre.com>
Subject: Re: [RESEND PATCH 0/2] hw_random: Add Amlogic Meson SoCs Random Generator driver
Date: Wed, 15 Jun 2016 08:57:04 -0700
Message-ID: <m2shweqwbz.fsf@baylibre.com>
References: <1465984906-17840-1-git-send-email-narmstrong@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Neil Armstrong <narmstrong@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465984906-17840-1-git-send-email-narmstrong@baylibre.com> (Neil
	Armstrong's message of "Wed, 15 Jun 2016 12:01:44 +0200")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Neil Armstrong <narmstrong@baylibre.com> writes:

> NOTE: This is a resent of the DT Bindings and DTSI patches based on the Amlogic DT 64bit
> GIT pull request from Kevin Hilman at [1].
>
> Changes since v2 at http://lkml.kernel.org/r/1465546915-24229-1-git-send-email-narmstrong@baylibre.com :
> - Move rng peripheral node into periphs simple-bus node

Thanks for the update.

Applied to the dt64 branch of the amlogic tree.

Kevin
