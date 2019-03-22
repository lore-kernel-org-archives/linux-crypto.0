Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3DBC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 07:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2C0F21902
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 07:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RmvbC5Gd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfCVHMB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 03:12:01 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:58951 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfCVHMB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 03:12:01 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id fe7aa1ea;
        Fri, 22 Mar 2019 06:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=Puz0M82KxhYw2A4w6o4V+yuXj
        Ko=; b=RmvbC5GdmcvOKCgXkmsosn2EMg1cVOTUJmI8yeVYmTo0Sj0Q5q2YIxeAs
        Uyaf5OVPgo43YW+h/I27kFd0SGu8Lo8WsyIyqnzDnyMe/JcTtQYrKtrlMcWFnooj
        nRJtzsTXhZGTKUt6u/PdVNT2aAGwXub/SdUIHXD8qpPl6EeswALueHRocvUzKHku
        pzPsXEKF/KHEyh+79Y0wdv0D4BIphZgkntK8t5SisRdIqjJW4Wp7LnI19i01Sxc9
        krZy3HkjETqOx0EsfAKF3w/bE0zbSYBMWiCjFssmJS1zU3X14LDxLUxR/y7x0iMt
        D44dXlriHgQWVhUGOZkmGq1dQQ9wA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1b833b90 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 22 Mar 2019 06:50:15 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH net-next v9 00/19] WireGuard: Secure Network Tunnel
Date:   Fri, 22 Mar 2019 01:11:03 -0600
Message-Id: <20190322071122.6677-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes v8->v9, along with who suggested it.
--------------------------------------------
- [EVERYBODY] Zinc no longer ships generated assembly code. Rather, we now
  bundle in the original perlasm generator for it. This is ongoing joint work
  with Andy Polyakov upstream, so that the same .pl files can live in our tree
  as well as in the CRYPTOGAMS tree. I personally find that the code required
  to share this in both repositories to be a tiny bit ugly. I think there would
  be some degree of an advantage to removing that and making the .pl
  kernel-only, and then carefully tracking Andy's changes (as we already
  do). Previous opinions on the list, though, were that there's also
  significant advantage to being able to share the exact same code in both.
  And I think there's a decent amount of wisdom in that too. Since that
  appeared to be the prevailing view, and since it also has good reasons
  arguments, we'll go with that for now.
  
  Meanwhile, Andy is recently back from some time away, and so we'll be
  improving these even further in the months to come. Already there are a few
  things ready that haven't been integrated here just yet.

- [Eric Biggers] In Zinc introductory commit, add more details on what Zinc is
  for and what the inclusion criteria are, as well as some notes on API.
- Clarify the peer removal logic and make lifetimes more precise.
- [Jann Horn] Use READ_ONCE for is_valid and is_dead.
- [Jann Horn] No need to use atomic when the recounter is mutex protected.
- [Andrew Lunn] Fix up macros and annotations in allowedips.
- [Andrew Lunn] Increment drop counter when staged packets are dropped.
- Use static constants instead of enums for 64-bit values in selftest.
- Mark large constants as ULL in poly1305-donna64.
- Fix sparse warnings in allowedips debugging code.
- Do not use wg_peer_get_maybe_zero in timer callbacks, since we now can
  carefully control the lifetime of these functions and ensure they never
  execute after dropping the last reference.
- Cleanup hashing in ratelimiter.
- Do not guard timer removals, since del_timer is always okay.
- [Theodore Ts'o, Andrew Lunn, Sultan Alsawaf] We now check for PM_AUTOSLEEP,
  which makes the clear-on-suspend decision a bit more general.
- Set csum_level to ~0, since the poly1305 authenticator certainly means
  that no data was modified in transit.
- [Andrejs Hanins] Use CHECKSUM_PARTIAL check for skb_checksum_help instead
  of skb_checksum_setup check.
- [Ard Biesheuvel] Enable the selftests by default, and leave it to
  small-system builders to disable this.
- [Sultan Alsawaf] We no longer allocate large hashtables as part of the
  net_device structure.
- Iteration of allowed IPs per peer now uses a normal boring fast linked
  list instead of needing to traverse a giant tree. This makes retrieving
  peer properties over netlink several orders of magnitude faster.
- The removal of all peers now includes two iterations through the peer
  list with a single synchronize_rcu_bh() in between iterations, as opposed
  to having one iteration, but a synchronize_rcu_bh() for every single peer.
- [Arnd Bergmann] 64-bit timestamps.
- The test suite now checks the validity of timestamps and checks that private
  keys are being properly clamped.
- Numerous API changes made in-tree since v8, such as shedding _bh() on a few
  functions and networking API changes and such.

- Following the Adiantum merge, the two commits that port the old crypto API
  over to use Zinc have been removed from this series. We can certainly add
  them back in at some point, but I thought it'd be favorable to at least
  begin to receive some sign-offs on the Zinc-specific commits, now that
  (hopefully all of) the previous feedback has been taken care of. The two
  commits porting it over are fairly standalone as well, so that shouldn't
  impact the ability to review this. For now those are living in the
  jd/with-cryptoapi-port branch of kernel.org's zx2c4/linux.git tree. This
  also allows us to move this all forward a little bit.

-----------------------------------------------------------

This patchset is available on git.kernel.org in this branch, where it may be
pulled directly for inclusion into net-next:

  * https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/log/?h=jd/wireguard

-----------------------------------------------------------

WireGuard is a secure network tunnel written especially for Linux, which
has faced around three years of serious development, deployment, and
scrutiny. It delivers excellent performance and is extremely easy to
use and configure. It has been designed with the primary goal of being
both easy to audit by virtue of being small and highly secure from a
cryptography and systems security perspective. WireGuard is used by some
massive companies pushing enormous amounts of traffic, and likely
already today you've consumed bytes that at some point transited through
a WireGuard tunnel. Even as an out-of-tree module, WireGuard has been
integrated into various userspace tools, Linux distributions, mobile
phones, and data centers. There are ports in several languages to
several operating systems, and even commercial hardware and services
sold integrating WireGuard. It is time, therefore, for WireGuard to be
properly integrated into Linux.

Ample information, including documentation, installation instructions,
and project details, is available at:

  * https://www.wireguard.com/
  * https://www.wireguard.com/papers/wireguard.pdf

As it is currently an out-of-tree module, it lives in its own git repo
and has its own mailing list, and every commit for the module is tested
against every stable kernel since 3.10 on a variety of architectures
using an extensive test suite:

  * https://git.zx2c4.com/WireGuard
    https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/WireGuard.git/
  * https://lists.zx2c4.com/mailman/listinfo/wireguard
  * https://www.wireguard.com/build-status/

The project has been broadly discussed at conferences, and was presented
to the Netdev developers in Seoul last November, where a paper was
released detailing some interesting aspects of the project. Dave asked
me after the talk if I would consider sending in a v1 "sooner rather
than later", hence this patchset. Zinc was presented at Kernel Recipes
in September, and a video is available online. Both Zinc and WireGuard
were presented at Plumbers in Vancouver in November.

  * https://www.wireguard.com/presentations/
  * https://www.wireguard.com/papers/wireguard-netdev22.pdf
  * Zinc talk: https://www.youtube.com/watch?v=bFhdln8aJ_U
  * Netdev talk: https://www.youtube.com/watch?v=54orFwtQ1XY

The cryptography in the protocol itself has been formally verified by
several independent academic teams with positive results, and I know of
two additional efforts on their way to further corroborate those
findings. The version 1 protocol is "complete", and so the purpose of
this review is to assess the implementation of the protocol. However, it
still may be of interest to know that the thing you're reviewing uses a
protocol with various nice security properties:

  * https://www.wireguard.com/formal-verification/

This patchset is divided into four segments. The first introduces a very
simple helper for working with the FPU state for the purposes of amortizing
SIMD operations. The second segment is a small collection of cryptographic
primitives, split up into several commits by primitive and by hardware. The
third shows a non-WireGuard use case for Zinc. The last is WireGuard itself,
presented as an unintrusive and self-contained virtual network driver.

It is intended that this entire patch series enter the kernel through
DaveM's net-next tree. Subsequently, WireGuard patches will go through
DaveM's net-next tree, while Zinc patches will go through Greg KH's tree in
cases when an entire development cycle has no relationships with existing code
in crypto/; however, if there are any relationships with code in crypto/, then
pull requests will be sent to Herbert instead in case there are merge
conflicts.

Enjoy,
Jason


Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Samuel Neves <samuel.c.p.neves@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
