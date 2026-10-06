Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66273D4132
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 23:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791328798; cv=none; b=G5n8aGBePi9rJYct6LGr3pNXHkw0WIfh6j0V5WnuxDaxX2qyfjUeRcUivwdz3YArlOwL450KejitxdgHYvz0Sn8vk/e3+FtyvB0wCPp0vxbCPl5Q6Aw80IFBYSubQ0msGehIhqx4fricA+2+lDbkpvlstiaWAtbLFQyEVaoO2mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791328798; c=relaxed/simple;
	bh=P7oecALR/wCKBNyKL3ajEPimn0nV+l81GMYEnAFRGkM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vGSWM/FfvWE+FAkUVm/dEKbTlmg3LdpL2kDikTPTmLUlZtLdBs/4tbF5NHBCtlB0VAAtRaYzvaFvNJWm5CnHyKGn14H9RpcA1bOjOg5H0LP1hnNVPmX0HovdMaLK69sgE+4V+MWtopGuWsVY9k8X6wQzjepv8LbO9c98zhAPbIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Qu9oONBi; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Qu9oONBi"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-150f88d22aeso2234778c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2026 16:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791328786; x=1791933586; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L71GPMsk4GSIdxEygBnLFVf0LVf2CMTomc/BzDysxCo=;
        b=Qu9oONBiAHrYHtYN59RK9IbVZz92On8/5XjZdNEzonq5e1IqjPuwZEdtTmph05NdrQ
         5g94TMWmD8iMlaMNgcRDdfgiVz+Y17r6mMsFj5fydMDQjuaUQcDIPEiv7EWrgOUVrtRZ
         WzAFxBPuNT41Z9M7b4SaudPb3WlMfkyeQadlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791328786; x=1791933586;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L71GPMsk4GSIdxEygBnLFVf0LVf2CMTomc/BzDysxCo=;
        b=oDfo+5Ped700RI67o6UEqdB1O1Qyg9pq9412Ho0IrjS8yYxoINAHPGWxdMLR7wxPg4
         CmUdSJXMg6TrjuVPOf1NlYZ2Q0zqr9v/w0Yq8cWEU7wEGHvBWlU99PM12lsDvMTQNoTQ
         dhxPkM+BxQqRPQnG/62MdV71IbHm9xU2aDS2Dvir1HC+JL327+XiO24V6pvlYvWOHpeG
         KiqwPxAZn77S31nriky79psEcQzGhiwjj5ysGuAJYeK0cEDfChhDLlAnWv2BT1T2qzzA
         yPsJt714xmvZlgc1VNw4/sj7i9nKneIpHIu5Azcb3kb4/+dZmxDBVC4sUSL1S9Uxwd9x
         b5Gg==
X-Forwarded-Encrypted: i=1; AKwUvByA/3+E/bWiPMxVVrtyA3Lr7HFt6fVVCpiRvlw3NRMd6FpgRumirWhUoecunAGU0tQH2yxdhJiJ9cTMBT4=@vger.kernel.org
X-Gm-Message-State: AFuF++mRtmvvAJkZJuMYMO2VNydt9TQ0s7qgkLHZ83xifdVL/mIxDkZj
	+0ycy5Z22sNCztnLIbINHOkjLltF2zrL8GV9j5W95c2wEmmcecR1eGQa8OfRoYeljQ==
X-Gm-Gg: AYBFou1YCzrQQQEEMwR7HFOcv1LtYLYeDDVd0WD20S5AghXdP3Ey/Hm6VUZ3F5NWav1
	BozXwgzN77UcAKMEhCsG7/DHdPRBq9+OTRYzZeV9DgxaV1jL6qzEZOrM+gzdcX9oMln/ry34lTx
	F5bMhhICH5thZdeWhC2a9rKlhV4rwDxXcjY+fWRoC/zA5cP/pX4dC8GoSj3lrFGZn9pknrDAFpE
	zSj2cBP+qTtFkNB/yKh35Z6nw9gqKVJ7Dfvv6NMUEeNlqCkUwfdGPQe+M0Zj3wxs1JbBXMP+GKY
	mkwNFbaHD2RczzgNDeki+NmJ594A+O6tToUQvl7IvsVjITNpI33xmp6bH66TJmqbD6PMD/SUdYb
	+UzPzDwE8pQ7Xd3HTSVZkVt0VpZiY61nYI4ncErIJt1RbRBOM/ezvViwIS+2w4LRrp/7QymUhPN
	3uAHcvGRxxrbsjCVvfB7wKvJrnXk0U19O/WTs/7ToQKmV3qEbguUu4u5Zr0A5rOJb1UOesVUID5
	mUAqet+zr9nqBi43KX/Fo75DORLL/Jxn1bE+A==
X-Received: by 2002:a05:701b:4553:10b0:151:7831:e401 with SMTP id a92af1059eb24-162045b8dcfmr323314c88.15.1791328785498;
        Tue, 06 Oct 2026 16:19:45 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:63eb:e7f9:1d47:7d47])
        by smtp.gmail.com with UTF8SMTPSA id a92af1059eb24-161680e191esm1583634c88.11.2026.10.06.16.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 16:19:44 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-pm@vger.kernel.org,
	Ulf Hansson <ulfh@kernel.org>,
	linux-kernel@vger.kernel.org,
	Brian Norris <briannorris@chromium.org>,
	"Bryan O'Donoghue" <bod@kernel.org>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Alex Elder <elder@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	David Lechner <dlechner@baylibre.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hadar Gat <hadar.gat@arm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jaroslav Kysela <perex@perex.cz>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jyri Sarha <jyri.sarha@iki.fi>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Mark Brown <broonie@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	Melissa Wen <mwen@igalia.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Olivia Mackall <olivia@selenic.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Rui Miguel Silva <rmfrfs@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Takashi Iwai <tiwai@suse.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	dri-devel@lists.freedesktop.org,
	greybus-dev@lists.linaro.org,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-staging@lists.linux.dev,
	sound-open-firmware@alsa-project.org
Subject: [PATCH 00/13] PM: runtime: Convert pm_runtime_put_autosuspend() and friends to a void function
Date: Tue,  6 Oct 2026 16:13:28 -0700
Message-ID: <20261006231900.3230373-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.56.0.360.g66cac248cb-goog
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Similar to this effort:

  Subject: [PATCH v1 00/23] PM: runtime: Convert pm_runtime_put() to a void function
  https://lore.kernel.org/all/6245770.lOV4Wx5bFT@rafael.j.wysocki/

i.e., commit 3afd8df02433 ("PM: runtime: Change pm_runtime_put() return
type to void") and friends.

As with pm_runtime_put(), there is very little value in return-code
checking for any of the other async __pm_runtime_suspend() and
__pm_runtime_idle() APIs:

  pm_runtime_put_autosuspend()
  pm_request_idle()
  pm_request_autosuspend()

Checking the return code is more likely to
produce a race condition (fighting with user space writing "on" to the
"control" attribute) than to tell a consumer useful info.

Nobody outside KUnit tests checks pm_request_idle() or
pm_request_autosuspend() return codes, but there are a number of
pm_runtime_put_autosuspend() callers that check its return code. Thus,
this series largely deals with pm_runtime_put_autosuspend().

Patches 1-11 are independent of each other, and similarly to the last
series, I expect the respective maintainers can pick them up. We can
apply patch 12 later. Patch 13 is also independent, but included in this
topic for completeness. It can be applied any time.

This touches a lot of trees/maintainers, so I tried to keep CC's only
for the relevant patch(es), plus the cover letter. I hope that's not too
noisy.

- Brian


Brian Norris (13):
  hwrng: cctrng: Discard pm_runtime_put_autosuspend() return value
  drm: Discard pm_runtime_put_autosuspend() return values
  iio: Discard pm_runtime_put_autosuspend() return values
  media: venus: Discard pm_runtime_put_autosuspend() return values
  pinctrl: qcom: lpass-lpi: Discard pm_runtime_put_autosuspend() return
    values
  spi: ti-qspi: Discard pm_runtime_put_autosuspend() return value
  greybus: Discard pm_runtime_put_autosuspend() return value
  ALSA: hda: Discard pm_runtime_put_autosuspend() return value
  ASoC: codecs: lpass: Discard pm_runtime_put_autosuspend() return
    values
  ASoC: intel: atom: Discard pm_runtime_put_autosuspend() return value
  ASoC: SOF: Discard pm_runtime_put_autosuspend() return values
  PM: runtime: Drop pm_runtime_put_autosuspend() return code
  PM: runtime: Drop pm_request_{idle,autosuspend}() return codes

 drivers/base/power/runtime-test.c             |  8 ---
 drivers/char/hw_random/cctrng.c               |  6 +-
 drivers/gpu/drm/panel/panel-simple.c          |  8 +--
 drivers/gpu/drm/tidss/tidss_drv.c             |  7 +--
 drivers/gpu/drm/v3d/v3d_drv.h                 |  4 +-
 drivers/iio/accel/bmc150-accel-core.c         | 14 ++---
 drivers/iio/accel/fxls8962af-core.c           | 11 +---
 drivers/iio/accel/kxcjk-1013.c                | 15 ++---
 drivers/iio/accel/mma8452.c                   | 15 +++--
 drivers/iio/accel/mma9551_core.c              | 15 +++--
 drivers/iio/adc/rcar-gyroadc.c                |  4 +-
 drivers/iio/adc/ti-ads1015.c                  |  8 +--
 drivers/iio/chemical/atlas-sensor.c           |  4 +-
 .../common/hid-sensors/hid-sensor-trigger.c   | 14 ++---
 drivers/iio/gyro/bmg160_core.c                | 17 +++--
 drivers/iio/gyro/fxas21002c_core.c            | 12 ++--
 drivers/iio/imu/kmx61.c                       | 17 +++--
 drivers/iio/light/apds9960.c                  |  2 +-
 drivers/iio/light/isl29028.c                  | 15 +----
 drivers/iio/light/pa12203001.c                |  3 +-
 drivers/iio/light/rpr0521.c                   | 15 +++--
 drivers/iio/light/tsl2583.c                   | 27 ++------
 drivers/iio/light/us5182d.c                   |  3 +-
 drivers/media/platform/qcom/venus/vdec.c      | 10 ++-
 drivers/media/platform/qcom/venus/venc.c      | 10 ++-
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c      | 16 +++--
 drivers/spi/spi-ti-qspi.c                     |  6 +-
 drivers/staging/greybus/power_supply.c        |  8 +--
 include/linux/greybus/bundle.h                | 12 +---
 include/linux/pm_runtime.h                    | 63 +++----------------
 include/sound/hdaudio.h                       |  8 +--
 sound/hda/core/device.c                       | 13 ++--
 sound/soc/codecs/lpass-rx-macro.c             |  4 +-
 sound/soc/codecs/lpass-tx-macro.c             |  4 +-
 sound/soc/codecs/lpass-va-macro.c             | 17 ++---
 sound/soc/codecs/lpass-wsa-macro.c            |  8 +--
 sound/soc/intel/atom/sst/sst.h                |  2 +-
 sound/soc/intel/atom/sst/sst_drv_interface.c  |  4 +-
 sound/soc/intel/atom/sst/sst_pvt.c            |  9 +--
 sound/soc/sof/control.c                       |  6 +-
 sound/soc/sof/sof-client-ipc-flood-test.c     |  5 +-
 .../soc/sof/sof-client-ipc-kernel-injector.c  |  4 +-
 sound/soc/sof/sof-client-ipc-msg-injector.c   |  6 +-
 sound/soc/sof/sof-client-probes.c             | 18 ++----
 44 files changed, 152 insertions(+), 325 deletions(-)

-- 
2.56.0.360.g66cac248cb-goog

