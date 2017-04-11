From: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 0/2] crypto: hw_random - Add new Exynos RNG driver
Date: Tue, 11 Apr 2017 20:08:33 +0200
Message-ID: <20170411180835.8928-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: James Hogan <james.hogan-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Javier Martinez Canillas <javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
        Bernie Thompson <bernie-5otTQG2S3XlWk0Htik3J/w@public.gmane.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-metag-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org,
        linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
Return-path: <linux-metag-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-metag-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi,

This is a follow up of my questions around exynos-rng [1].

Changes since v4:
=================
1. Patch 2/2: Use "stdrng" name, as suggested by Herbert.
2. Patch 2/2: Add Bartlomiej's reviewed-by.

Changes since v3:
=================
1. New patch: 1/2 for ALIGN_DOWN macro. The change in metag architecture
   was not compiled. Please test it.
2. Dropped patches touching ARM defconfig as they are not changing and
   they pollute this submission.
3. Utilize all seed provided by kcapi (suggested by Stephan Müller).
4. Drop dev->ctx (suggested by PrasannaKumar Muralidharan).
5. Remove any printks from set_seed callback as this might be a way
   for unprivileged user to pollute the log (suggested by Stephan).
6. Minor cleanups: initialize 'read' variable in exynos_rng_reseed()
   for readability (it is not strictly required).
7. Add review tags from Stephen and PrasannaKumar.


Changes since v2:
=================
1. Do not re-use random numbers for re-seed (neither for system resume
   nor for periodic re-seed).  Instead the driver will just generate new
   random numbers (suggested by Stephan Müller).

   Suspend path tested with suspend-to-freeze, not real suspend. Testing
   on Trats2 would be welcomed.

Changes since v1:
=================
1. Re-work the code for seeding after system resume, following suggestions
   and review by Stephan Müller.

2. Re-seed itself from time to time (every 100 ms), suggested by Stephan
   Müller.

3. Use a define for retries (Bartlomiej Zolnierkiewicz).
4. Add some docs.


Description:
============
The existing exynos-rng has many issues.  The most important one is that
it is a pseudo RNG device but uses hw_random interface which does not allow
proper seeding.

The RNG module on Exynos4 requires seeding.  On newer SoCs (like Exynos5420)
it can seed itself from a true RNG.  Converting the existing driver
to use TRNG would effectively drop support for Exynos4 and break
compatibility with existing users.

Instead I decided to convert it to crypto API.  In the future I hope
to add support for seeding from TRNG module.

Tested with app [2].

Patches are independent. I will take the defconfig changes (2/3 and 3/3)
through samsung-soc tree.

Best regards,
Krzysztof

[1] https://www.spinics.net/lists/arm-kernel/msg569641.html
[2] https://www.spinics.net/lists/arm-kernel/msg571184.html

Krzysztof Kozlowski (2):
  linux/kernel.h: Add ALIGN_DOWN macro
  crypto: hw_random - Add new Exynos RNG driver

 MAINTAINERS                         |   8 +
 arch/metag/kernel/stacktrace.c      |   2 -
 drivers/char/hw_random/Kconfig      |  14 --
 drivers/char/hw_random/Makefile     |   1 -
 drivers/char/hw_random/exynos-rng.c | 231 ---------------------
 drivers/crypto/Kconfig              |  15 ++
 drivers/crypto/Makefile             |   1 +
 drivers/crypto/exynos-rng.c         | 389 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/udl/udl_fb.c        |   2 +-
 include/linux/kernel.h              |   1 +
 include/video/udlfb.h               |   2 +-
 11 files changed, 416 insertions(+), 250 deletions(-)
 delete mode 100644 drivers/char/hw_random/exynos-rng.c
 create mode 100644 drivers/crypto/exynos-rng.c

-- 
2.9.3
