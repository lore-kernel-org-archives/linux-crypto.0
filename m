Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4904EC77B75
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 04:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjEOE4r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 00:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEOE4q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 00:56:46 -0400
X-Greylist: delayed 1333 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 21:56:41 PDT
Received: from a27-52.smtp-out.us-west-2.amazonses.com (a27-52.smtp-out.us-west-2.amazonses.com [54.240.27.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B381EE73
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 21:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684125268;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
        bh=r6c3/lQyX/E8+aAyavuFwemjmoLaGwLDqBf2HVjnXqo=;
        b=MKJCR5w8HKas5WBydD7nJeZUfb/O8YliJD8Owi57XZ6qjNWXFQf6zYXtS2vWrnVH
        O2uKeEXSJtzqiILyoxtWFWT767w0QQAtmTXrpSozIELgQ2ARYGzuK7Shz/jyncOLYEL
        mX3bM9SAAndF5wU7Jl4bhIJfudmEuwklUYnpKkLXEZ2ysSRut10TD18GXa99uRq2jxH
        FwaIFVGJ4qDnTzYG6EcshHEqCit0tTblkgqPa3iHEGYSt79QqHVHl37mvP9OCCr9I31
        +ag3ehjRKpaOlW8eqFagSq6IAdfleNHQijsP2JGQz3m1+T8ea1TeCa3bCvymLHLUALz
        SVpwYyfEGg==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684125268;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
        bh=r6c3/lQyX/E8+aAyavuFwemjmoLaGwLDqBf2HVjnXqo=;
        b=eYPk2n3tIFvCGvVeDC0uJb7+4G0iJo+BgAwof++3SLKsZXYYtWWreorFg/Ma+w3E
        /sLa1yoxtAdOZmEPtw5y5zGMoY1wcoeqmLYuMTzkdHXbmAkFDXCytQr1/1+3jHAQlBE
        E+WUKQ0ibt0zrpSzeuwkky/0cv+6yFUfB18OtoP0=
From:   FUJITA Tomonori <tomo@exabit.dev>
To:     rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: [PATCH 2/2] rust: add socket support
Date:   Mon, 15 May 2023 04:34:28 +0000
Message-ID: <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515043353.2324288-1-tomo@exabit.dev>
References: <20230515043353.2324288-1-tomo@exabit.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.15-54.240.27.52
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

minimum abstraction for networking.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
---
 rust/bindings/bindings_helper.h |   3 +
 rust/kernel/lib.rs              |   2 +
 rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+)
 create mode 100644 rust/kernel/net.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 65683b9aa45d..7cbb5dd96bf6 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -7,8 +7,11 @@
  */
 
 #include <crypto/hash.h>
+#include <linux/net.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
+#include <linux/socket.h>
+#include <linux/tcp.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
 
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 753fd62b84f1..42dbef3d9e88 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -40,6 +40,8 @@ pub mod crypto;
 pub mod error;
 pub mod init;
 pub mod ioctl;
+#[cfg(CONFIG_NET)]
+pub mod net;
 pub mod prelude;
 pub mod print;
 mod static_assert;
diff --git a/rust/kernel/net.rs b/rust/kernel/net.rs
new file mode 100644
index 000000000000..204b5222abdc
--- /dev/null
+++ b/rust/kernel/net.rs
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Networking.
+//!
+//! C headers: [`include/linux/net.h`](../../../../include/linux/net.h),
+//! [`include/linux/socket.h`](../../../../include/linux/socket.h),
+
+use crate::{
+    bindings,
+    error::{to_result, Result},
+};
+use alloc::vec::Vec;
+
+/// Represents `struct socket *`.
+///
+/// # Invariants
+///
+/// The pointer is valid.
+pub struct Socket {
+    pub(crate) sock: *mut bindings::socket,
+}
+
+impl Drop for Socket {
+    fn drop(&mut self) {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        unsafe { bindings::sock_release(self.sock) }
+    }
+}
+
+/// Address families. Defines AF_* here.
+pub enum Family {
+    /// Internet IP Protocol.
+    Ip = bindings::AF_INET as isize,
+}
+
+/// Communication type.
+pub enum SocketType {
+    /// Stream (connection).
+    Stream = bindings::sock_type_SOCK_STREAM as isize,
+}
+
+/// Protocols.
+pub enum Protocol {
+    /// Transmission Control Protocol.
+    Tcp = bindings::IPPROTO_TCP as isize,
+}
+
+impl Socket {
+    /// Creates a [`Socket`] object.
+    pub fn new(family: Family, sf: SocketType, proto: Protocol) -> Result<Self> {
+        let mut sock = core::ptr::null_mut();
+
+        // SAFETY: FFI call.
+        to_result(unsafe {
+            bindings::sock_create_kern(
+                &mut bindings::init_net,
+                family as _,
+                sf as _,
+                proto as _,
+                &mut sock,
+            )
+        })
+        .map(|_| Socket { sock })
+    }
+
+    /// Moves a socket to listening state.
+    pub fn listen(&mut self, backlog: i32) -> Result {
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::kernel_listen(self.sock, backlog) })
+    }
+
+    /// Binds an address to a socket.
+    pub fn bind(&mut self, addr: &SocketAddr) -> Result {
+        let (addr, addrlen) = match addr {
+            SocketAddr::V4(addr) => (
+                addr as *const _ as _,
+                core::mem::size_of::<bindings::sockaddr>() as i32,
+            ),
+        };
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::kernel_bind(self.sock, addr, addrlen) })
+    }
+
+    /// Accepts a connection
+    pub fn accept(&mut self) -> Result<Self> {
+        let mut client = core::ptr::null_mut();
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        to_result(unsafe { bindings::kernel_accept(self.sock, &mut client, 0) })
+            .map(|_| Socket { sock: client })
+    }
+
+    /// Receives a message from a socket.
+    pub fn recvmsg(&mut self, bufs: &mut [&mut [u8]], flags: i32) -> Result<usize> {
+        let mut msg = bindings::msghdr::default();
+        let mut kvec = Vec::try_with_capacity(bufs.len())?;
+        let mut len = 0;
+        for i in 0..bufs.len() {
+            len += bufs[i].len();
+            kvec.try_push(bindings::kvec {
+                iov_base: bufs[i].as_mut_ptr().cast(),
+                iov_len: bufs[i].len(),
+            })?;
+        }
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        let r = unsafe {
+            bindings::kernel_recvmsg(
+                self.sock,
+                &mut msg,
+                kvec.as_mut_ptr(),
+                bufs.len(),
+                len,
+                flags,
+            )
+        };
+        to_result(r).map(|_| r as usize)
+    }
+
+    /// Sends a message through a socket.
+    pub fn sendmsg(&mut self, bufs: &[&[u8]]) -> Result<usize> {
+        let mut msg = bindings::msghdr::default();
+        let mut kvec = Vec::try_with_capacity(bufs.len())?;
+        let mut len = 0;
+        for i in 0..bufs.len() {
+            len += bufs[i].len();
+            kvec.try_push(bindings::kvec {
+                iov_base: bufs[i].as_ptr() as *mut u8 as _,
+                iov_len: bufs[i].len(),
+            })?;
+        }
+        // SAFETY: The type invariant guarantees that the pointer is valid.
+        let r = unsafe {
+            bindings::kernel_sendmsg(self.sock, &mut msg, kvec.as_mut_ptr(), bufs.len(), len)
+        };
+        to_result(r).map(|_| r as usize)
+    }
+}
+
+/// A socket address.
+pub enum SocketAddr {
+    /// An IPv4 socket address.
+    V4(SocketAddrV4),
+}
+
+/// Represents `struct in_addr`.
+#[repr(transparent)]
+pub struct Ipv4Addr(bindings::in_addr);
+
+impl Ipv4Addr {
+    /// Creates a new IPv4 address from four eight-bit octets.
+    pub const fn new(a: u8, b: u8, c: u8, d: u8) -> Self {
+        Self(bindings::in_addr {
+            s_addr: u32::from_be_bytes([a, b, c, d]).to_be(),
+        })
+    }
+}
+
+/// Prepresents `struct sockaddr_in`.
+#[repr(transparent)]
+pub struct SocketAddrV4(bindings::sockaddr_in);
+
+impl SocketAddrV4 {
+    /// Creates a new IPv4 socket address.
+    pub const fn new(addr: Ipv4Addr, port: u16) -> Self {
+        Self(bindings::sockaddr_in {
+            sin_family: Family::Ip as _,
+            sin_port: port.to_be(),
+            sin_addr: addr.0,
+            __pad: [0; 8],
+        })
+    }
+}
+
+/// Waits for a full request
+pub const MSG_WAITALL: i32 = bindings::MSG_WAITALL as i32;
-- 
2.34.1

