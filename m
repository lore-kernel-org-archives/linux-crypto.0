Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3C03E0C58
	for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787217966; cv=none; b=sUxib7j7PO5s27hsV28bv36uMlTy3/Zxz780R7jXRGeFDPjp7MllNymFPYFIlNK3qKsTXdCGuX1zqS5Jj4WOCbYYTziTtHLWw3yqK070cHqOLp/5R/5/zUxW8wNjtRs/4vjBXSW4RwpfJrUk1BDG8QQ4KY/spbA43eyAOm2YNw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787217966; c=relaxed/simple;
	bh=0cDrkYAjtURPtK9fvYPRJPTJZ7snxhYzFu4rhGIVgHk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=s1zlokUlbdl6uYtEv9a6xxHbOEeDz+965IyWvhvUD4aFmLP63Oneazgb5CewTVQq+k6H3o62fs+w1hCbbZ0wA56sam2nwB8yE4oDPZgFjS0aAUDo6G3Wa4aqJYVLoZLk5atnwLHAAVegc7tYpBaQE0A9ZGi5ryi9OmODFPF2yvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard-org.20251104.gappssmtp.com header.i=@beagleboard-org.20251104.gappssmtp.com header.b=P3TDBpJz; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard-org.20251104.gappssmtp.com header.i=@beagleboard-org.20251104.gappssmtp.com header.b="P3TDBpJz"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso453655a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 02:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard-org.20251104.gappssmtp.com; s=20251104; t=1787217957; x=1787822757; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j17TQtBzxI0K32ey43+T3tYD2S9k4Rou5QMcghyn3cQ=;
        b=P3TDBpJzZt/mC8xTegCDGb+bhng1pl01T+sVwX9MWLcK3VdQYzouqi6l+sZlurpfbm
         QJenjMCAkW04xjfpy4uM0T/W+3yStbXtjdlbRYHA3f+ayciRWS8SB3PUUV8YF9ksSXYC
         oEptZBsuoH77CjmkBDqz41x2aCwzKGYnOOE73B/doZ0ZJnwVaRaADHecv5ZWaAaILdiu
         oj8jQ63fSs62+tgYE/s9++WITAMM69b0oKS6jx2eyEMSJQ/aBQ4b5+ckXIDXI789P8Gu
         QQN3DT/V8bfRqEXJj2+TerUgUmG1F5LwtLK4T+VUBRrMaRVNmtNjLBPNe0LdNfPQFD4b
         uolg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787217957; x=1787822757;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=j17TQtBzxI0K32ey43+T3tYD2S9k4Rou5QMcghyn3cQ=;
        b=R3NBLJtZfO2NqwcSQlT9z+VmNvYDZ0KO7MINJ4WHlIYxTyWahXIDThjGlYpiu/w+QG
         f4xRzPnET99NHrG9D8viZYbVrPj0SDsBBQmzw6wO+j0m8IHfHUov1sbWIOwkDgqWL1vp
         /qFpqsmPPkIeyFcpWkzAfQmuippytjUC6QSfg2vSQGjs3DEMnHpp5Dy7V8Kr/u+Y5VDA
         KJRFHCJP+emLNraPl2rUtMEtvcrPkacvzv1ym8COzLN7V9kmOcfU/9Mlqctdv5b6Xsq3
         HHvkllOc5XtHNkOwMkHOywAJAvwZnHnhPQcohagRpEg97RhFz/ZNCbO+zq4K5JUoRt7B
         TXdw==
X-Forwarded-Encrypted: i=1; AHgh+RpB77hFcV2gUr8RG2YaLc/NRqvC/ZAKoBf8JTOaPI9R/vnb5Cq8igcORIDu3u9zNKyWO1j+nOrR8SVAdDs=@vger.kernel.org
X-Gm-Message-State: AFuF++kzq0brWb7344L8bim7rY5XzZzR0Q6CTBgT3oRdX6uWxe5rtA/7
	dJOfDCNlxwji3macRaShSbOMrcX9BToYoH0m7Uu1nySzvMaUzJHelcVZWgzNcHgdjw==
X-Gm-Gg: AR+sD11IrBzLwFG/lrjpo29wJPGUgmfjbl2XYBkL+41ENCUtZnfVT2ZSpZuF+10DRRU
	Ij7FXooETJ+aWz9HrdiLkTZUc25n0KQCF0s5a2H5uKs7N4Z/9rlNU4czT239s/usoQ5EoN14ViL
	t1H8XblK/D+i84ASh2VIIeJS3tMVnimPrCZew+G27htxVc2Om+zNdiSHKe2LovZGOiK62K7iWrR
	HyNRRZvkHbZL1vlMiDnL1gJNk1nyJRtP5ZSdfFszvhjPmVY7axo5RpuJtbTT+27ejTfEVYhZtyQ
	EWsnMQ91J9Jd1rNh6rWahvqvUxuTD/GC9S5Q+bUlxYeQ0r8G3Jrigy7bPyRb694BquweIggf35e
	Fujj3ZMZhPdp1dm5CEKJV3TVrQfcS1+LH+ArAlu8BCsYy4UNCzbRZ1tqsDEO2vYAXxmoPwr8VSi
	ltTU4uHs/U+mXY0TWLzNo3sBXXkR6hiCvpcnTFEj6q2vIW407TrsU9KfjNpoOL2sKt05YxsCg=
X-Received: by 2002:a17:90a:d883:b0:38e:7e9b:5fbc with SMTP id 98e67ed59e1d1-395a04e402emr6859537a91.7.1787217957424;
        Thu, 20 Aug 2026 02:25:57 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad6060asm25903254c88.6.2026.08.20.02.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 02:25:57 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Subject: [PATCH 0/7] Add Greybus Sotfsvc and UART Node drivers
Date: Thu, 20 Aug 2026 14:55:42 +0530
Message-Id: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MywqAIBAAf0X2nKCSvX4lOphttReT1SKI/j3pN
 nOYeSAhEyYYxAOMFyU6QhFdCfC7CxtKWoqDUaZRnVZym+XpOMvMLqR4FOqNtUtjbetrD6WLjCv
 d/3Oc3vcDlhplh2MAAAA=
X-Change-ID: 20260810-gb-uart-transport-9255d6557c4c
To: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, 
 Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6707; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=0cDrkYAjtURPtK9fvYPRJPTJZ7snxhYzFu4rhGIVgHk=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqhsgcbGkB2c8AEwYTDVd0KeW41XTUxHzqQH00H
 tg1aMBh1T+JAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCaobIHAAKCRAFzvXHieVa
 dKTDD/wKdYvi7QeSNASUf6+pLphrEikFwSL6/UV9En9aX5L1bZZG8639FEJ7otHlV+rp+RjNyEX
 aC0VKSOt31U0QOos/spHgnNogbK2IM+Fn9tXOsm0OaL+aesRzUnxb/SMFX8eOkCqbL5XDEY9ZdZ
 qlHpx2021h5l0QL7JtQ99ZWJvAgl0hAGbs+eaS7rYHmAsZY39T9noaDC2BR50JQFaBSMwj3etN7
 Hd7lwkD4/NWB8yqhQt7GA8+G/6iXtJOJBlk/J3BpNyfyTrq/7RJtyG5Dkj4eblfzftHOdUyfAEt
 8MOieOKTfg5s5jurlSPbwcoEj8GEUcxFsza/XPuzSgWjFoHYN2dCH/xPUzsc7wNfNP3r/gg4fYp
 BGfDK/OZ15w+zrfeFIcmHoKXaKOBdWgUwK6oGs+wRCS5PWjXY5CtwZL6a2E9a74Spi9jm8iFgGB
 PRDv43EklgLLWEajFAny8j9DSJHFQYTz7DSi2PcKQ0ZpzTYDueklavwocKzgDCfYSMlJkU5BZKz
 Alw5e0sZY0mxY1+dDhDRJK+lenvFkhmUgTqlS43Pa8MFlG3ctE+9tWAwQu1i5SZgsSKXhijr4Cf
 kQvJPyp+2qajmwqH79nZMmIf4IE/qWGk178GVlf8f5exOJD6voc9WOQdcz46G4pxcke+IAVEglF
 yrQsZosEJIcUg5w==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

A Greybus network needs an SVC (Supervisory Controller) to bring
interfaces up, assign device IDs and connect CPorts to the AP. On a
UniPro network the SVC is a real entity on the bus. On transports that
merely carry Greybus messages - a UART, an I2C bus, a network link -
nothing on the wire plays that role, so the SVC has to be emulated
somewhere: in a user-space bridge (gbridge), in coprocessor firmware
(cc1352p7 in gb-beagleplay), or open-coded inside the host driver itself.

This series moves the emulation into the kernel and makes it shared.
This was discussed in a prior RFC as well [2], but to keep things short,
removing the need for an external SVC greatly simplifies the greybus
network setup when nodes are directly connected over common transports
such as UART, I2C etc.
 
    gb-uart-node          gb-softsvc              greybus core
   (transport, serdev) <-> (SVC + host device) <-> (bundles, protocols)
        NodeOps            module_insert()
     submit_message()      module_remove()

gb-softsvc registers itself as a Greybus host device and answers the
SVC-side operations the core expects during interface bring-up and
teardown. A host driver implements the NodeOps trait to push data
towards its node, calls module_insert() to announce a new node,
submit_message() to hand incoming Greybus messages back to the core,
and module_remove() on disconnect.

The first user is gb-uart-node, a driver for Greybus nodes attached over
a plain serial port. Framing is HDLC, with a one-byte address (0x01 for
Greybus) and control byte, followed by the 16-bit CPort ID and the
Greybus message. No SVC firmware is required on the far end, so the node
can be a bare microcontroller speaking Greybus - a BeagleConnect Freedom
over its serial link, in this case. The testing is performed with
greybus-zephyr [0] implementation.

Both drivers are written in Rust, which is why the middle of the series
is abstractions rather than drivers. Only the APIs these two drivers
need are covered: protocols.rs abstracts the SVC-facing parts of
greybus_protocols.h, and types such as Greybus Interface do not
implement AlwaysRefCounted yet. The intent is to grow this as more Rust
host drivers appear rather than to abstract the whole subsystem up
front.

Patches 1 and 2 are small C-side preparations to the Greybus core:
exporting gb_connection_get()/gb_connection_put() and adding
gb_connection_hd_find_by_intf(), a lookup by remote interface and CPort
id for callers that only know the far end of a connection. Patch 3 adds
a CRC-CCITT abstraction, needed for HDLC frame checks. Patch 4 adds the
Greybus abstractions, patches 5 and 6 the two drivers, and patch 7 the
device tree binding for BeagleConnect Freedom.

Open questions 
***************

- gb-uart-node imports types from gb-softsvc, so the series carries the
  Rust-to-Rust cross-module calling setup from nova-core [1]:
  gb_softsvc_exports.c plus the Makefile plumbing that emits crate
  metadata and generates the export list. This is a workaround for the
  build system not supporting Rust cross-module dependencies natively,
  and it should go away once that lands.

- Connection create/destroy and interface activate/resume in gb-softsvc
  currently just acknowledge the request. Callbacks into NodeOps can be
  added when a transport actually needs to act on them; I did not want
  to invent an interface without a user.

- Zerocopy is currently not being used in grebeybus/protocols.rs. They
  cannot be derived yet since types generated by bindgen do not have
  them, and it seems explicitly forbindden to manually impl the traits.
  So using old traits from transmute.

- The bindings are supposed to be created for actual device, but any MCU
  that supports Zephyr, can run the greybus-zephyr firmware with UART
  transport. So not sure if adding a beagle,beagleconnect-freedom
  compatible is the correct choice here.

- The individual patches can be spun off into independent patch series
  if required. The reason for this single patch series is to provide a
  complete picture of usage.

- Since gb-softsvc currently is not being used from a C driver, no C API
  is provided. However, if required, it can be added.

- Writing to UART from gb-uart-node is currently a bit broken. I am not
  quite sure what the safe way is to go from a non-bound device to a
  bound device. Any suggestions on this front are welcome.

- I am not sure if Rust abstractions should have a seperate entry in
  MAINTAINERS with me as the maintainer, or if they should just be added
  to the respective subsystem entries.

[0]: https://github.com/beagleboard/greybus-zephyr
[1]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc977@nvidia.com/
[2]: https://lore.kernel.org/all/ecca8eb2-8e5a-4770-bcf6-3fb49773088b@beagleboard.org/

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
Ayush Singh (7):
      greybus: connection: Export gb_connection_get() and gb_connection_put()
      greybus: connection: Add gb_connection_hd_find_by_intf()
      rust: crc_ccitt: add CRC-CCITT abstraction
      rust: kernel: Add greybus abstractions
      drivers: greybus: Add software SVC implementation
      greybus: Add Rust UART node driver
      dt-bindings: beagle: Add BeagleConnect Freedom

 .../beagle/beagle,beagleconnect-freedom.yaml       |  30 ++
 MAINTAINERS                                        |  15 +
 drivers/greybus/.gitignore                         |   1 +
 drivers/greybus/Kconfig                            |  27 ++
 drivers/greybus/Makefile                           |  50 +++
 drivers/greybus/connection.c                       |  28 +-
 drivers/greybus/gb_softsvc.rs                      | 472 +++++++++++++++++++++
 drivers/greybus/gb_softsvc_exports.c               |  15 +
 drivers/greybus/gb_uart_node.rs                    | 231 ++++++++++
 include/linux/greybus/connection.h                 |   6 +
 lib/crc/Kconfig                                    |   7 +
 rust/bindings/bindings_helper.h                    |   2 +
 rust/kernel/crc_ccitt.rs                           |  26 ++
 rust/kernel/greybus/hd.rs                          | 315 ++++++++++++++
 rust/kernel/greybus/mod.rs                         | 230 ++++++++++
 rust/kernel/greybus/protocols.rs                   | 392 +++++++++++++++++
 rust/kernel/lib.rs                                 |   4 +
 17 files changed, 1849 insertions(+), 2 deletions(-)
---
base-commit: 6b8c8af514d739d0335f5579b585e02babe8a727
change-id: 20260810-gb-uart-transport-9255d6557c4c

Best regards,
-- 
Ayush Singh <ayush@beagleboard.org>

